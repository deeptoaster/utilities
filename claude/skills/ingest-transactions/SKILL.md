---
name: ingest-transactions
description: "Transform tabular data exported from a credit card or bank statement into the user's strict TSV format. Use when asked to import or ingest credit card or bank transactions from pasted or uploaded data."
---

# Purpose

The user maintains a spreadsheet-based accounting system consisting of expense, income, and transfer tables whose entries are aggregated into accounts including:

* cash (separated by currency)
* checking and savings accounts
* investment and retirement accounts
* credit cards and financing
* public transportation cards
* store credit values
* balances on Venmo and other payment systems
* friends (balance receivable minus payable)

The user needs to ingest data from numerous sources, including Splitwise records, bank and credit card statements, and manually recorded cash transactions. Your goal is to generate pristine and accurate tables from these transactions that can be copied directly into the user's spreadsheets.

# Input format

In general, the user will paste a table containing transaction data from the account's website, which will be in whatever format that account's institution uses. The user should also provide you with the name of the account to associate with the transactions.

# Output format

The output is also tabular, but must follow the user's strict table formats. Output consists of one or more of the three tables below, each with their own specific format.

## Expense table

Expenses include purchases made for the user's benefit.

The expense table consists of eight columns:

1. Date (of transaction)
2. Debit account (the vendor's human-readable name, as it would appear on Google Maps, in ASCII characters with no diacritics)
3. Credit account (the user's account associated with the transaction)
4. Category—one of:
    * Class (includes instruction time, museum visits, gym memberships, etc.)
    * Dining (includes restaurants, takeout, food delivery, and Too Good To Go)
    * Gifts (includes half of transactions paid for on dates; see below)
    * Groceries
    * Lodging (includes utilities, rent, hotels, storage units, etc.)
    * Luxuries (miscellaneous personal purchases that are "wants")
    * Medical (includes pharmacy purchases and doctor's visits)
    * Necessities (miscellaneous personal purchases that are "needs")
    * Recreation (includes bar purchases, alcohol purchases, tickets to shows, etc.)
    * Transportation (includes rental car payments, parking and toll fees, public transport costs, etc.)
5. Subtotal (total minus tax)
6. Tax (location-dependent sales tax; see below)
7. Total (this should match the number in the input transaction)
8. Cash back (see below)

## Income table

The income table consists of six columns:

1. Date (of transaction)
2. Debit account (the user's account into which the income was deposited)
3. Credit account (the source of the income)
4. Subtotal (total minus tax)
5. Tax (zero unless the user indicates otherwise)
6. Total (this should match the number in the input transaction)

## Transfer table

Purchases on behalf of friends, for which the user can reasonably expect to paid back, should go in the transfer table. So should transfers between the user's accounts, such as credit card payments, and transfers between the user and other users, such as settling of debts.

The transfer table consists of five columns:

1. Date (of transaction)
2. Debit account
3. Credit account
4. Total
5. Cash back (see below)

# Other notes

## Tax

Record location-dependent US sales tax, rounded to the nearest cent. For foreign transactions, record 0.

1.  Compute subtotal = (total / (1 + tax rate)).
2.  Compute tax = (subtotal * tax rate).
3.  If the computed subtotal + tax does not equal the total, round the subtotal down as necessary, or round the tax up as necessary.

See the section on **Accuracy** for more details.

Purchases at grocery stores are usually not taxed, although this may vary by jurisdiction.

### Brick-and mortar purchases (restaurants, bars, in-person retail, etc.)

Apply the flat sales tax rate for the physical location of purchase. Some common tax rates:

    - New York City: 8.875%
    - San Francisco: 8.625%
    - Oregon: 0%
    - Boston: 7%
    - Sunnyvale: 9.125%

### Online purchases (flights, e-retailers, etc.)

If available, pull the tax breakdown from a confirmation email or receipt rather than estimating by location. Search for emails between two days before and two days after the post date. This may be marked as "taxes and fees," "external taxes and charges," etc. If no receipt is available, default to NYC tax rate.

If a receipt shows a discount (such as from a promo code), record it as a separate line in the purchase table with `Discount` as the credit account. Discounts are not taxed.

## Cash back

The cash back column contains the percentage of the total cost the user can expect to receive back on the transaction, whether it's an expense or transfer, counting credit card points and merchant offer rewards. See below for a description of merchant offers.

If there is a cash back column (which may be indicated as "rewards" or "points") in the input table, compute cash back = ((points / 100 + merchant offers reward) / total). That is, credit card points should be valued at one cent per point.

If there is not a cash back column in the input table, let the user provide the cash back percentages on various purchase categories, which are associated with credit card vendor codes and are unrelated to the Category column described above. If a merchant offer reward applies, these percentages should be correct to account for it.

Output cash back values should always be an integer followed by the percent sign.

### Merchant Offers

When a statement includes a "Merchant Offers Credit" (or similar credit), ask the user which transaction it corresponds to. Then:

1.  Increase that transaction's cash back percentage to reflect the offer, according to the formula above.
2.  Record the reward in the transfer table on the date it was rewarded (not the day the purchase was made) with `Cash back` as the credit account.

### Default values

Unless otherwise specified, cash back values are as below.

#### Prestige Card

*   10% back on Citi Travel portal purchases (statement descriptor `CITI TRAVEL HOTEL`)
*   5% back on airfare, restaurants, bars, and travel agencies
*   3% back on hotels not through Citi Travel
*   1% back on everything else

#### Strata Card

*   5% back on Citi Travel portal purchases
*   3% back on grocery stores, gas and EV charging, transit, and a self-select category that the user should specify
*   2% back on restaurants
*   1% back on everything else

#### Custom Cash Card

*   5% back on a category the user should specify
*   1% back on everything else

#### Costco Card

*   5% back on gas at Costco
*   4% back on other gas and EV charging
*   3% back on restaurants and travel
*   2% back on other Costco purchases
*   1% back on everything else

#### Double Cash Card

*   2% back on everything

## Vendor name normalization

Statement descriptors often reflect the payment processor (e.g. "SQ *", "TST*", "Too Good To Go Inc.") rather than the actual establishment. Use the real business name as it would appear on Google Maps, in ASCII with no diacritics.

Some statement descriptors are systematically wrong and should always be replaced:

- `TWP*` → `The Washington Post` (Gifts, 0% tax, 1% cash back)
- `Cafe Hugo` → `Felix Roasting`
- `TST* STOUT NYC - AMITY` → `Amity Hall`

### Too Good To Go

TGTG charges appear on statements as "Too Good To Go Inc." and require Gmail lookup to determine the actual restaurant name and transaction date.

At the start of ingestion, retrieve snippets for all TGTG transactions by using `search_threads` with `subject:"Thank you for your order" from:toogoodtogo` filtered to a date window between two days before the earliest post date in the batch and the last post date in the batch.

The snippet alone contains all needed information: the restaurant name appears as "Your order for [Name] has been successfully placed!" and the transaction date immediately follows as the collection date. No full email fetch is needed. If multiple TGTG charges fall on the same date, distinguish them first by amount, then by collection time..

TGTG charges ending in `.99` are typically untaxed digital transactions; all others use the standard rate for the pickup location (usually NYC).

## Statement dates: transaction date vs. post date

Always record the transaction date in the output table, falling back to the post date only if the transaction date is not available. In general, if a line in the user's input starts with two dates, the first is the transaction date and the second is the post date; if there is only one, it is the post date.

For brick-and-mortar transactions, cross-reference Google Calendar to find the actual visit date:

1.  At the start of ingestion, fetch the full calendar event list between two days before the first earliest post date in the batch (`startTime`) and the last post date in the batch (`endTime`), using `Google Calendar:list_events` with `orderBy: startTime`. Fetch from the three calendars Default, Job, and School.
2.  For each brick-and-mortar transaction, find the calendar event whose location or summary matches the vendor and whose start date is within two days before the post date, if available. Use that event's start date as the transaction date.
3.  If no matching calendar event exists, use the specified transaction date, if available.
4.  If no transaction date is available, fall back to the post date.

The calendar is assumed accurate. If a calendar event matches the vendor but spans two calendar days (e.g. a bar visit starting before midnight and ending after), use the date closest to the transaction or post date in the input.

## Accuracy

Complete accuracy of the output is absolutely essential. If there is anything unclear about the data, all questions should be compiled and asked to the user together. Wait until all questions are resolved before presenting the output table(s).

Numerical accuracy is absolutely essential. Decide what needs to be computed (such as tax amounts), batch the calculations, and use code to perform the actual computation.

If corrections are requested, confirm with the user that all corrections have been made before presenting the output table(s) again.

## Dates

If a user indicates that a transaction is a date, it should be recorded as two entries in the output: one with half the amount (including half the tax) recorded as normal, and one with the other half recorded as Gifts (but with the same debit and credit accounts). If the original amount was an odd number of cents, the non-Gifts entry should round up and the Gifts entry should round down.

## Purchase returns

Purchase returns should be recorded in the same way as purchases but with negative amounts.