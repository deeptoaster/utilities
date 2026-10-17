---
name: ingest-transactions
description:
    "Transform credit card or bank statement tables and earnings statement PDFs
    into paste-ready TSV rows for the user's Expenses, Income, and Transfers
    ledgers. Use when asked to import or ingest transactions, paychecks, or
    earnings statements from pasted or uploaded data."
---

# Purpose

The user maintains a Google Sheet with three ledgers (Expenses, Income, and
Transfers) whose entries are aggregated into accounts including:

- cash (separated by currency)
- checking and savings accounts
- investment and retirement accounts
- credit cards and financing
- public transportation cards
- store credit values
- balances on Venmo and other payment systems
- friends (balance receivable minus payable)

The user needs to ingest data from numerous sources, including Splitwise
records, bank and credit card statements, earnings statement PDFs, and manually
recorded cash transactions. Your goal is to generate pristine and accurate rows
from these transactions that can be pasted directly into the user's ledgers.

# Input format

In general, the user will paste a table containing transaction data from the
account's website, which will be in whatever format that account's institution
uses. The user should also provide you with the name of the account to
associate with the transactions. Income arrives as ADP earnings statement PDFs
(e.g. `earnings_2026-09-25.pdf`); see **Earnings statements** below. Credit
card statements may also arrive as PDFs (e.g. `October 13.pdf`, a Citi
statement); extract their text with `pdftotext -layout`. In the transaction
lines, the first two columns are the transaction date and the post date (a line
with one date has only the post date), followed by the statement descriptor and
the amount.

The user may also provide a CSV exported from the sheet (e.g.
`Q3 2026 - Transactions.csv`) to compare the output against. It has the same
column layout as the sheet, contains every account rather than only the one
being ingested, shows negative amounts in parentheses, and exports computed
values rather than formulas. It was entered by hand, so a disagreement may be a
typo in the sheet rather than an error in the output: report every disagreement
instead of silently matching the sheet.

# Output format

The output is pasted directly into the Google Sheet, interleaved with existing
rows, so it is produced as tab-separated values (TSV) with no header row.
Google Sheets splits pasted tab-separated text into cells and evaluates pasted
cells that begin with `=` as formulas; pasted CSV would land in a single
column. Because the formulas use A1 references, ask the user for the sheet row
into which the first output row will be pasted (`--first-row`). The three
ledgers sit side by side in one sheet per quarter, with the Date column of
Expenses in column B, Income in column K, and Transfers in column R; the
scripts default to these columns and `--first-column` overrides them.

Always produce the TSV with the scripts in `scripts/` (see **Scripts**), which
do all arithmetic and formula generation. Present each ledger in two forms: a
Markdown table in chat for review, and the raw TSV piped to `pbcopy` so that
the user can paste it straight into the sheet with a single cell selected. If
the clipboard is unavailable, write the TSV to a `.tsv` file in the working
directory and point the user at it; copying a table out of the chat does not
preserve tabs reliably.

Output consists of one or more of the three tables below, each with their own
specific format.

## Expense table

Expenses include purchases made for the user's benefit.

The expense table consists of eight columns:

1.  Date (of transaction)
2.  Debit account (the vendor's human-readable name, as it would appear on
    Google Maps, in ASCII characters with no diacritics)
3.  Credit account (the user's account associated with the transaction)
4.  Category—one of:
    - Class (includes instruction time, museum visits, gym memberships, etc.)
    - Dining (includes restaurants, takeout, food delivery, and Too Good To Go)
    - Gifts (includes half of transactions paid for on dates; see below)
    - Groceries
    - Lodging (includes utilities, rent, hotels, storage units, etc.)
    - Luxuries (miscellaneous personal purchases that are "wants")
    - Medical (includes pharmacy purchases and doctor's visits)
    - Necessities (miscellaneous personal purchases that are "needs")
    - Recreation (includes bar purchases, alcohol purchases, tickets to shows,
      etc.)
    - Transportation (includes rental car payments, parking and toll fees,
      public transport costs, etc.)
5.  Subtotal (total minus tax)
6.  Tax (location-dependent sales tax; see below)
7.  Total (formula `=<Subtotal cell>+<Tax cell>`; it must evaluate to the
    number in the input transaction)
8.  Cash back (see below)

## Income table

The income table consists of six columns:

1.  Date (of transaction)
2.  Debit account (the user's account into which the income was deposited, or
    the provider paid by a payroll deduction)
3.  Credit account (the source of the income)
4.  Subtotal (total plus tax)
5.  Tax (zero unless the user indicates otherwise; negative for a tax refund,
    e.g. from `IRS`)
6.  Total (formula `=<Subtotal cell>-<Tax cell>`; it must evaluate to the
    amount received)

### Earnings statements

Each earnings statement becomes one row per account that money flowed to, all
dated with the advice date and credited to the employer:

- the deposit account (e.g. `Citi Savings`): subtotal = net pay + taxes
  withheld, tax = taxes withheld;
- one row per non-zero deduction (pre- and post-tax) and per imputed-income
  earnings item (`GTL`, `LTD Imputed Inc`), debited to the provider (`VSP`,
  `Aetna`, `Unum`, `T. Rowe Price 401(k)`, ...) with zero tax.

`scripts/parse_earnings.py` does this and checks that earnings total − taxes −
those items = net pay, refusing to produce output otherwise. The account
mappings live at the top of the script; an unmapped item is emitted with a
`TODO` debit account and reported on stderr, and must be resolved with the user
before the output is presented.

## Transfer table

Purchases on behalf of friends, for which the user can reasonably expect to
paid back, should go in the transfer table. So should transfers between the
user's accounts, such as credit card payments, and transfers between the user
and other users, such as settling of debts.

The transfer table consists of five columns:

1.  Date (of transaction)
2.  Debit account
3.  Credit account
4.  Total
5.  Cash back (see below)

# Other notes

## Tax

Record location-dependent US sales tax, rounded to the nearest cent. For
foreign transactions, record 0.

Given a total and a tax rate, `split_total` in `scripts/ledger.py`
(`ledger.py split TOTAL RATE` for one value; `ledger.py format` applies it to
whole tables) computes:

1.  subtotal = ROUND(total / (1 + tax rate), 2)
2.  tax = ROUND(subtotal × tax rate, 2)
3.  If subtotal + tax = total, the Tax cell is the formula
    `=ROUND(<Subtotal cell>*<tax rate>,2)`.
4.  Otherwise the subtotal is rounded down (toward zero) instead and the
    residual goes to the tax: the Tax cell is the plain number total −
    subtotal. For example, 23.00 at 8.875% gives 21.12 and 1.88.

A half-cent tie in step 2 is treated as unsafe for a formula, because
spreadsheet floating point may round it the other way. When the tax amount is
known exactly (from a receipt), give `tax` instead of `tax_rate` and it is
recorded as a plain number.

Purchases at grocery stores are usually not taxed, although this may vary by
jurisdiction.

### Brick-and mortar purchases (restaurants, bars, in-person retail, etc.)

Apply the flat sales tax rate for the physical location of purchase. Some
common tax rates:

    -   New York City: 8.875%
    -   San Francisco: 8.625%
    -   Oregon: 0%
    -   Boston: 7%
    -   Sunnyvale: 9.125%

### Online purchases (flights, e-retailers, etc.)

If available, pull the tax breakdown from a confirmation email or receipt
rather than estimating by location. Search for emails between two days before
and two days after the post date. This may be marked as "taxes and fees,"
"external taxes and charges," etc. If no receipt is available, default to NYC
tax rate.

If a receipt shows a discount (such as from a promo code), record it as a
separate line in the purchase table with `Discount` as the credit account.
Discounts are not taxed.

## Cash back

The cash back column contains the percentage of the total cost the user can
expect to receive back on the transaction, whether it's an expense or transfer,
counting credit card points and merchant offer rewards. See below for a
description of merchant offers.

If there is a cash back column (which may be indicated as "rewards" or
"points") in the input table, compute cash back = ((points / 100 + merchant
offers reward) / total). That is, credit card points should be valued at one
cent per point.

If there is not a cash back column in the input table, let the user provide the
cash back percentages on various purchase categories, which are associated with
credit card vendor codes and are unrelated to the Category column described
above. If a merchant offer reward applies, these percentages should be correct
to account for it.

Output cash back values should always be an integer followed by the percent
sign.

### Merchant Offers

When a statement includes a "Merchant Offers Credit" (or similar credit), ask
the user which transaction it corresponds to. Then:

1.  Increase that transaction's cash back percentage to reflect the offer,
    according to the formula above.
2.  Record the reward in the transfer table on the date it was rewarded (not
    the day the purchase was made) with `Cash back` as the credit account.

### Default values

Unless otherwise specified, cash back values are as below.

#### Prestige Card

- 10% back on Citi Travel portal purchases (statement descriptor
  `CITI TRAVEL HOTEL`)
- 5% back on airfare, restaurants, bars, and travel agencies
- 3% back on hotels not through Citi Travel
- 1% back on everything else

#### Strata Card

- 5% back on Citi Travel portal purchases
- 3% back on grocery stores, gas and EV charging, transit, and a self-select
  category that the user should specify
- 2% back on restaurants
- 1% back on everything else

#### Custom Cash Card

- 5% back on a category the user should specify
- 1% back on everything else

#### Costco Card

- 5% back on gas at Costco
- 4% back on other gas and EV charging
- 3% back on restaurants and travel
- 2% back on other Costco purchases
- 1% back on everything else

#### Double Cash Card

- 2% back on everything

## Vendor name normalization

Statement descriptors often reflect the payment processor (e.g. "SQ _", "TST_",
"Too Good To Go Inc.") rather than the actual establishment. Use the real
business name as it would appear on Google Maps, in ASCII with no diacritics.

Some statement descriptors are systematically wrong and should always be
replaced:

- `TWP*` → `The Washington Post` (Gifts, 0% tax, 1% cash back)
- `Cafe Hugo` → `Felix Roasting`
- `TST* STOUT NYC - AMITY` → `Amity Hall`

### Too Good To Go

TGTG charges appear on statements as "Too Good To Go Inc." and require Gmail
lookup to determine the actual restaurant name and transaction date.

At the start of ingestion, retrieve snippets for all TGTG transactions by using
`search_threads` with `subject:"Thank you for your order" from:toogoodtogo`
filtered to a date window between two days before the earliest post date in the
batch and the last post date in the batch.

The snippet alone contains all needed information: the restaurant name appears
as "Your order for [Name] has been successfully placed!" and the transaction
date immediately follows as the collection date. No full email fetch is needed.
If multiple TGTG charges fall on the same date, distinguish them first by
amount, then by collection time..

TGTG charges ending in `.99` are typically untaxed digital transactions; all
others use the standard rate for the pickup location (usually NYC).

## Statement dates: transaction date vs. post date

Always record the transaction date in the output table, falling back to the
post date only if the transaction date is not available. In general, if a line
in the user's input starts with two dates, the first is the transaction date
and the second is the post date; if there is only one, it is the post date.

For brick-and-mortar transactions, cross-reference Google Calendar to find the
actual visit date:

1.  At the start of ingestion, fetch the full calendar event list between two
    days before the first earliest post date in the batch (`startTime`) and the
    last post date in the batch (`endTime`), using
    `Google Calendar:list_events` with `orderBy: startTime`. Fetch from the
    three calendars Default, Job, and School.
2.  For each brick-and-mortar transaction, find the calendar event whose
    location or summary matches the vendor and whose start date is within two
    days before the post date, if available. Use that event's start date as the
    transaction date.
3.  If no matching calendar event exists, use the specified transaction date,
    if available.
4.  If no transaction date is available, fall back to the post date.

The calendar is assumed accurate. If a calendar event matches the vendor but
spans two calendar days (e.g. a bar visit starting before midnight and ending
after), use the date closest to the transaction or post date in the input.

## Accuracy

Complete accuracy of the output is absolutely essential. If there is anything
unclear about the data, all questions should be compiled and asked to the user
together. Wait until all questions are resolved before presenting the output
table(s).

Numerical accuracy is absolutely essential. Never compute amounts by hand:
write the rows as JSON and let `scripts/ledger.py` compute subtotals, taxes,
date splits, and formulas.

If corrections are requested, confirm with the user that all corrections have
been made before presenting the output table(s) again.

## Dates

If a user indicates that a transaction is a date, it should be recorded as two
entries in the output: one with half the amount (including half the tax)
recorded as normal, and one with the other half recorded as Gifts (but with the
same debit and credit accounts). If the original amount was an odd number of
cents, the non-Gifts entry should round up and the Gifts entry should round
down. Set `"is_date": true` on the row and `scripts/ledger.py` performs the
split.

## Purchase returns

Purchase returns should be recorded in the same way as purchases but with
negative amounts.

# Scripts

Both scripts live in `scripts/` next to this file and take `--first-row N` (the
sheet row of the first pasted row) and optionally `--first-column` (default
`A`).

- `ledger.py` (standard library only):
  `python3 scripts/ledger.py format LEDGER rows.json --first-row N | pbcopy`.
  Write one JSON file per ledger; amounts and rates are strings so that they
  are read exactly. Keys per row:
    - all ledgers: `date` (`"25 Sep"` or `"2026-09-25"`), `debit`, `credit`
    - expenses: `category`, `total`, and either `tax_rate` (e.g. `"0.08875"`)
      or `tax` (exact amount); optional `cash_back` (integer percent) and
      `is_date`
    - transfers: `total`, optional `cash_back`
    - income: `subtotal` (or `total`), optional `tax`
- `parse_earnings.py` (needs the `pdftotext` command from poppler):
  `python3 scripts/parse_earnings.py --first-row N earnings_*.pdf | pbcopy`.
  Pass `--json` instead to get `ledger.py` income rows for inspection or
  merging with other income.

Example expense rows:

```json
[
    {
        "date": "2026-10-03",
        "debit": "Amity Hall",
        "credit": "Prestige Card",
        "category": "Dining",
        "total": "54.43",
        "tax_rate": "0.08875",
        "cash_back": 5
    },
    {
        "date": "5 Oct",
        "debit": "Delta Air Lines",
        "credit": "Prestige Card",
        "category": "Transportation",
        "total": "312.60",
        "tax": "23.40",
        "cash_back": 5
    }
]
```
