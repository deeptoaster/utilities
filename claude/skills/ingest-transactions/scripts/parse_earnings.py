#!/usr/bin/env python3
"""Turn ADP earnings statement PDFs into paste-ready Income ledger rows.

Usage:
    parse_earnings.py --first-row N STATEMENT.pdf [STATEMENT.pdf ...]
    parse_earnings.py --json STATEMENT.pdf    # rows for ledger.py instead of TSV

Requires the pdftotext command (poppler). One row goes to the deposit account (net pay plus taxes
withheld, with the taxes in the Tax column), then one row per non-zero deduction and imputed-income
item, in ACCOUNT_ORDER order. Items with no account mapping are emitted with a TODO debit account
and reported on stderr.
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from decimal import Decimal
from pathlib import Path
from typing import TypedDict

from ledger import Row, format_rows

DEPOSIT_ACCOUNTS = {"6945": "Citi Savings"}
EMPLOYERS = {"CoStar Realty Information, Inc.": "CoStar"}
ACCOUNT_ORDER = {
    "Vision": "VSP",
    "Dental": "Aetna",
    "GTL": "Unum",
    "LTD Imputed Inc": "Unum",
}
IMPUTED_INCOME_ITEMS = {"GTL", "LTD Imputed Inc"}
LEFT_TABLES = ["earnings", "pre_tax_deductions"]
RIGHT_TABLES = ["employee_taxes", "post_tax_deductions", "taxable_wages"]
COLUMN_SPLIT = 76
NUMBER_PATTERN = re.compile(r"^-?\d[\d,]*(\.\d+)?$")

Table = dict[str, Decimal]


class Statement(TypedDict):
    date: str
    deposit_suffix: str
    net_pay: Decimal
    employer: str
    earnings_total: Decimal
    taxes_total: Decimal
    imputed_income: Table
    deductions: Table


def extract_lines(pdf_path: Path) -> list[tuple[list[str], list[str]]]:
    """Return (left_words, right_words) per line of the layout-preserving text."""
    text = subprocess.run(
        ["pdftotext", "-layout", str(pdf_path), "-"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout
    return [
        (line[:COLUMN_SPLIT].split(), line[COLUMN_SPLIT:].split())
        for line in text.splitlines()
        if line.strip()
    ]


def parse_item(words: list[str]) -> tuple[str, Decimal | None]:
    """Split a table line into (description, current amount); the last two numbers are current and year-to-date."""
    numbers = [word for word in words if NUMBER_PATTERN.match(word)]
    description = " ".join(word for word in words if not NUMBER_PATTERN.match(word))
    return (
        (description, Decimal(numbers[-2].replace(",", "")))
        if len(numbers) >= 2
        else (description, None)
    )


def parse_tables(
    half_lines: list[list[str]], table_names: list[str]
) -> dict[str, Table]:
    tables: dict[str, Table] = {name: {} for name in table_names}
    table_index = -1
    for words in half_lines:
        if words[:1] == ["Description"]:
            table_index += 1
        elif table_index >= 0 and words:
            description, current = parse_item(words)
            if current is not None:
                tables[table_names[min(table_index, len(table_names) - 1)]][
                    description
                ] = current
    return tables


def parse_statement(pdf_path: Path) -> Statement:
    lines = extract_lines(pdf_path)
    tables = parse_tables([left for left, _ in lines], LEFT_TABLES) | parse_tables(
        [right for _, right in lines], RIGHT_TABLES
    )
    text = " ".join(word for left, right in lines for word in left + right)
    advice_date = re.search(r"Advice Date: (\d\d)/(\d\d)/(\d{4})", text)
    deposit = re.search(r"X+(\d{4}) \d+ \$(-?[\d,]+\.\d\d)", text)
    employer = next(
        (
            short
            for long, short in EMPLOYERS.items()
            if long.replace(" ", "") in text.replace(" ", "")
        ),
        None,
    )
    if not (advice_date and deposit and employer):
        raise SystemExit(
            f"{pdf_path}: could not find advice date, deposit line, or employer"
        )
    month, day, year = advice_date.groups()
    return {
        "date": f"{year}-{month}-{day}",
        "deposit_suffix": deposit.group(1),
        "net_pay": Decimal(deposit.group(2).replace(",", "")),
        "employer": employer,
        "earnings_total": tables["earnings"].pop("Earnings Total"),
        "taxes_total": tables["employee_taxes"].pop("Taxes Total"),
        "imputed_income": {
            key: value
            for key, value in tables["earnings"].items()
            if key in IMPUTED_INCOME_ITEMS
        },
        "deductions": tables["pre_tax_deductions"] | tables["post_tax_deductions"],
    }


def build_rows(statement: Statement) -> list[Row]:
    items = statement["deductions"] | statement["imputed_income"]
    nonzero = {
        description: amount for description, amount in items.items() if amount != 0
    }
    gap = (
        statement["earnings_total"]
        - statement["taxes_total"]
        - sum(nonzero.values(), Decimal(0))
        - statement["net_pay"]
    )
    if gap != 0:
        raise SystemExit(
            f"earnings do not reconcile: {gap} unexplained (items: {nonzero})"
        )
    deposit_account = DEPOSIT_ACCOUNTS.get(
        statement["deposit_suffix"],
        f"TODO: account ending {statement['deposit_suffix']}",
    )
    rows = [
        {
            "date": statement["date"],
            "debit": deposit_account,
            "credit": statement["employer"],
            "subtotal": str(statement["net_pay"] + statement["taxes_total"]),
            "tax": str(statement["taxes_total"]),
        }
    ]
    ordered = [
        description for description in ACCOUNT_ORDER if description in nonzero
    ] + [description for description in nonzero if description not in ACCOUNT_ORDER]
    for description in ordered:
        account = ACCOUNT_ORDER.get(description, f"TODO: {description}")
        rows.append(
            {
                "date": statement["date"],
                "debit": account,
                "credit": statement["employer"],
                "subtotal": str(nonzero[description]),
                "tax": "0",
            }
        )
    todo = [row["debit"] for row in rows if row["debit"].startswith("TODO")]
    if todo:
        print(
            f"{statement['date']}: ask the user which account to use for {', '.join(todo)}",
            file=sys.stderr,
        )
    return rows


def main() -> None:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("statements", nargs="+", type=Path)
    parser.add_argument(
        "--first-row",
        type=int,
        help="sheet row the first output row will be pasted into",
    )
    parser.add_argument("--first-column", default="A")
    parser.add_argument(
        "--json",
        action="store_true",
        help="print rows as JSON for ledger.py instead of TSV",
    )
    arguments = parser.parse_args()
    if not (arguments.json or arguments.first_row):
        parser.error("--first-row is required unless --json is given")
    rows = [
        row
        for statement in arguments.statements
        for row in build_rows(parse_statement(statement))
    ]
    if arguments.json:
        json.dump(rows, sys.stdout, indent=2)
    else:
        sys.stdout.write(
            format_rows("income", rows, arguments.first_row, arguments.first_column)
        )


if __name__ == "__main__":
    main()
