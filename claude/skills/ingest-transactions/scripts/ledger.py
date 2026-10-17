#!/usr/bin/env python3
"""Format ledger rows as TSV that pastes straight into the Expenses, Income, and Transfers sheets.

Usage:
    ledger.py split TOTAL TAX_RATE
    ledger.py format {expenses,income,transfers} ROWS.json --first-row N [--first-column B] [--header]

ROWS.json is a list of objects. Common keys: date ("25 Sep" or "2026-09-25"), debit, credit.
    expenses:  category, total, and one of tax_rate (e.g. "0.08875") or tax (explicit amount);
               optional cash_back (integer percent) and is_date (split into a normal half and a Gifts half)
    income:    subtotal or total, optional tax (default 0)
    transfers: total, optional cash_back
Amounts should be given as strings so that they are read exactly.
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from datetime import date
from decimal import ROUND_CEILING, ROUND_FLOOR, ROUND_HALF_UP, Decimal
from typing import Optional, Union

CENT = Decimal("0.01")

COLUMNS = {
    "expenses": [
        "Date",
        "Debit account",
        "Credit account",
        "Category",
        "Subtotal",
        "Tax",
        "Total",
        "Cash back",
    ],
    "income": ["Date", "Debit account", "Credit account", "Subtotal", "Tax", "Total"],
    "transfers": ["Date", "Debit account", "Credit account", "Total", "Cash back"],
}

FIRST_COLUMNS = {"expenses": "B", "income": "K", "transfers": "R"}

InputRow = dict[str, Union[str, bool]]
Row = dict[str, str]


@dataclass
class TaxSplit:
    subtotal: Decimal
    tax: Decimal
    tax_rate: Decimal
    is_formula_safe: bool


def round_cents(value: Decimal | str, rounding: str = ROUND_HALF_UP) -> Decimal:
    return Decimal(value).quantize(CENT, rounding=rounding)


def split_total(total: Decimal | str, tax_rate: Decimal | str) -> TaxSplit:
    """Split a tax-inclusive total into subtotal and tax.

    The tax is formula-safe when ROUND(subtotal * tax_rate, 2) reproduces it exactly and
    is not a half-cent tie (which spreadsheets may round differently from Decimal).
    Otherwise the residual goes to the tax.
    """
    total, tax_rate = Decimal(total), Decimal(tax_rate)
    base_subtotal = round_cents(total / (1 + tax_rate))
    exact_tax = base_subtotal * tax_rate
    is_tie = abs(exact_tax * 100) % 1 == Decimal("0.5")
    is_formula_safe = (
        tax_rate != 0 and base_subtotal + round_cents(exact_tax) == total and not is_tie
    )
    return TaxSplit(base_subtotal, total - base_subtotal, tax_rate, is_formula_safe)


def format_amount(value: Decimal | str) -> str:
    return f"{Decimal(value):,.2f}"


def format_date(value: str) -> str:
    parsed = date.fromisoformat(value) if "-" in value else None
    return f"{parsed.day} {parsed:%b}" if parsed else value


def format_cash_back(value: str | int) -> str:
    text = str(value)
    return text if text.endswith("%") else f"{int(Decimal(text))}%"


def column_letter(ledger: str, column_name: str, first_column: str) -> str:
    return chr(ord(first_column) + COLUMNS[ledger].index(column_name))


def expand_dates(rows: list[InputRow]) -> list[Row]:
    """Split rows flagged is_date into a normal half (rounded up) and a Gifts half (rounded down)."""
    expanded = []
    for row in rows:
        text_row = {key: value for key, value in row.items() if isinstance(value, str)}
        if row.get("is_date"):
            half_total = Decimal(text_row["total"]) / 2
            halves = [(ROUND_CEILING, text_row["category"]), (ROUND_FLOOR, "Gifts")]
            for rounding, category in halves:
                half_row = {
                    **text_row,
                    "total": str(round_cents(half_total, rounding)),
                    "category": category,
                }
                if "tax" in text_row:
                    half_row["tax"] = str(
                        round_cents(Decimal(text_row["tax"]) / 2, rounding)
                    )
                expanded.append(half_row)
        else:
            expanded.append(text_row)
    return expanded


def build_money_cells(
    ledger: str, row: Row, sheet_row: int, first_column: str
) -> list[str]:
    subtotal_cell = f"{column_letter(ledger, 'Subtotal', first_column)}{sheet_row}"
    tax_cell = f"{column_letter(ledger, 'Tax', first_column)}{sheet_row}"
    if ledger == "income":
        tax = Decimal(row.get("tax", "0"))
        subtotal = (
            Decimal(row["subtotal"])
            if "subtotal" in row
            else Decimal(row["total"]) + tax
        )
        cells = [
            format_amount(subtotal),
            format_amount(tax),
            f"={subtotal_cell}-{tax_cell}",
        ]
    elif "tax" in row:
        tax = Decimal(row["tax"])
        cells = [
            format_amount(Decimal(row["total"]) - tax),
            format_amount(tax),
            f"={subtotal_cell}+{tax_cell}",
        ]
    else:
        split = split_total(row["total"], row.get("tax_rate", "0"))
        tax_text = (
            f"=ROUND({subtotal_cell}*{split.tax_rate},2)"
            if split.is_formula_safe
            else format_amount(split.tax)
        )
        cells = [
            format_amount(split.subtotal),
            tax_text,
            f"={subtotal_cell}+{tax_cell}",
        ]
    return cells


def build_cells(ledger: str, row: Row, sheet_row: int, first_column: str) -> list[str]:
    cells = [format_date(row["date"]), row["debit"], row["credit"]]
    if "Category" in COLUMNS[ledger]:
        cells.append(row["category"])
    if "Subtotal" in COLUMNS[ledger]:
        cells.extend(build_money_cells(ledger, row, sheet_row, first_column))
    else:
        cells.append(format_amount(row["total"]))
    if "Cash back" in COLUMNS[ledger]:
        cells.append(format_cash_back(row.get("cash_back", 0)))
    return cells


def format_rows(
    ledger: str,
    rows: list[InputRow],
    first_row: int,
    first_column: Optional[str] = None,
    header: bool = False,
) -> str:
    column = first_column or FIRST_COLUMNS[ledger]
    lines = ["\t".join(COLUMNS[ledger])] if header else []
    for offset, row in enumerate(expand_dates(rows)):
        lines.append("\t".join(build_cells(ledger, row, first_row + offset, column)))
    return "\n".join(lines) + "\n"


def load_rows(path: str) -> list[InputRow]:
    with open(path) if path != "-" else sys.stdin as handle:
        return json.load(handle, parse_float=str, parse_int=str)


def main() -> None:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    subparsers = parser.add_subparsers(dest="command", required=True)
    split_parser = subparsers.add_parser(
        "split", help="split one total into subtotal and tax"
    )
    split_parser.add_argument("total")
    split_parser.add_argument("tax_rate")
    format_parser = subparsers.add_parser(
        "format", help="format JSON rows as paste-ready TSV"
    )
    format_parser.add_argument("ledger", choices=sorted(COLUMNS))
    format_parser.add_argument("rows", help="JSON file of rows, or - for stdin")
    format_parser.add_argument(
        "--first-row",
        type=int,
        required=True,
        help="sheet row the first output row will be pasted into",
    )
    format_parser.add_argument(
        "--first-column",
        help="sheet column of the Date column (default: where the ledger sits in the sheet)",
    )
    format_parser.add_argument("--header", action="store_true")
    arguments = parser.parse_args()
    if arguments.command == "split":
        split = split_total(arguments.total, arguments.tax_rate)
        print(
            f"subtotal={split.subtotal} tax={split.tax} formula_safe={split.is_formula_safe}"
        )
    else:
        sys.stdout.write(
            format_rows(
                arguments.ledger,
                load_rows(arguments.rows),
                arguments.first_row,
                arguments.first_column,
                arguments.header,
            )
        )


if __name__ == "__main__":
    main()
