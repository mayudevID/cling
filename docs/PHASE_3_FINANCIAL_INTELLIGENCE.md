# Phase 3 Financial Intelligence

## Architecture

The calculations are pure Dart in `core/financial_intelligence.dart`. `DatabaseRepository` reads account-scoped SQLite projections and returns canonical integer minor-unit inputs. `FinancialInsightsBloc` uses repository revision and request generation checks to discard stale loads. Cling Check is a read-only simulation, Insights are regenerated from the current local ledger, and goal planning saves only the goal metadata the user explicitly confirms. No AI or external financial service is used.

## Cling Check rules

The first release restricts planned purchases to today because reliable future balance forecasting is unavailable. The input accepts an item, positive amount, active source wallet, and optional note. It never writes an expense or otherwise changes the ledger.

- `available balance` and `spendable before` come from the Payday Runway projection: active same-currency wallet balances minus unpaid bills, pending recurring obligations, and safety reserve.
- `selected wallet after` is selected wallet balance minus purchase amount.
- `spendable after` is spendable before minus purchase amount.
- `daily allowance after` is `max(0, spendable after) ~/ days to payday`.
- Expected future income is shown separately and is not included as cash.
- A mixed-currency or missing payday projection is unavailable. A purchase can still be identified as exceeding the selected wallet's cash.

Assessment order is explicit: selected-wallet shortfall; projected spendable shortfall; caution; otherwise within estimated budget. Caution is shown when the purchase consumes at least 25% of spendable funds, or reduces estimated daily allowance by at least 20%. These thresholds live in `ClingCheckThresholds`. The result is an estimate, not a guarantee.

## Cling Insights rules

Insights query expense ledger rows only; transfers, bills not yet paid, opening balances, and goal contributions do not enter spending aggregates. The current month-to-date is compared with the same calendar-day span of the prior month (clamped to that month's final day). Insights are suppressed if the comparison has fewer than three transactions per period or its baseline is below 10,000 minor units. At most one overall and one category trend are generated.

- Category share requires at least two current-month transactions and at least 15% of recorded expenses; only the leading category is shown.
- Category trend requires at least three transactions in each comparable period and a prior category baseline of at least 10,000 minor units; the largest percentage movement is chosen.
- Spending pace requires at least three current-month expenses, a saved monthly budget, at least 50% budget use, and spending at least 10 percentage points ahead of the calendar month elapsed.
- Upcoming commitment insight uses the Payday Runway's deduplicated bills and recurring occurrences. No payday projection means no commitment claim.
- Goal progress reports contributions tracked this month and explicitly says they do not move wallet money.
- Results are deterministically ranked: upcoming commitments, spending pace, trends, category share, then positive tracked goal progress. Insight IDs are stable for a month/category or planning date.
- Cross-currency expense history or active wallets suppresses aggregated Insights; no currency conversion is performed.

## Smart Savings Goals

Schema v5 adds nullable target date, contribution frequency, priority, and informational planning-wallet columns to `goal_meta`. Existing goal IDs, target/collected minor units, and contribution rows are untouched. The v5 migration is idempotent and runs in SQLite's create/upgrade transaction; backup validation accepts v1–v5 and checks v5 columns plus foreign keys. Restored v1–v4 backups receive the normal forward migration when opened.

Remaining target is `target minor - collected minor`. Required weekly/monthly contribution is ceiling division by remaining periods, so the estimate does not underfund due to truncation. Weekly periods use seven-day calendar spans; monthly periods count calendar months to the selected deadline. If there is no deadline, required contribution and feasibility remain unknown. A recent-pace completion estimate uses contribution history over a 90-day observation window. A what-if contribution computes a separate projected date without saving it. The optional reference wallet is informational; when selected, recommendation capacity is conservatively limited by its available balance and currency. Affordability uses current Payday Runway discretionary allowance and stays unknown without a valid same-currency projection.

Saving a goal plan updates the target/settings only when the user taps Save. Existing contribution add/delete behavior remains atomic and tracking-only. Neither goal metadata nor goal contributions create wallet transactions or expense statistics.

## Migration and compatibility

Schema v5 only adds nullable goal planning columns and date/category indexes. It does not rewrite financial records or assign dates to legacy goals. The normal UID-specific database lifecycle, backup checksum/owner checks, rollback protection, and restore flow are unchanged. Rollback requires restoring the prior per-UID snapshot; older app versions cannot represent goal planning metadata after it is saved.

## Known limitations and release risks

- Cling Check only models a purchase made today. Future-dated forecast is intentionally unavailable.
- Insights are unavailable when the queried active/history data crosses wallet currency boundaries; this release does not convert currencies.
- Insights use account monthly budget only when its display-currency preference agrees with active wallet currency. Otherwise spending-pace insight is omitted.
- Goal historical pace is an estimate over the last 90 calendar days and is not a promise of future contributions.
- Goal contributions remain tracking-only. A linked wallet is a planning reference, not segregated or funded cash.
- Existing generic Statistics screens still aggregate expense minor units without currency grouping; Cling Insights guards its own projections. Mixed-currency use in the older Statistics screen remains a Phase 1 limitation.
- Quick Add UI, wallet transaction filters, and transfer edit/delete are still documented Phase 1 work and are outside this phase.

## Tests and manual verification

Automated tests cover integer purchase assessment, source-wallet shortfall, missing/mixed-currency estimate, sparse/zero-baseline insight suppression, period/category insight ordering, ceiling contribution math, what-if completion, legacy goals, tracking-only accounting, v4→v5 preservation, and SQLite integrity/foreign-key checks. `fvm flutter test` passed all 60 tests. `fvm flutter analyze` reported 674 `info` lints and no warnings/errors; the command exits non-zero because repository info lints are treated as issues.

Manual checks before release:

1. Simulate a purchase with enough overall funds but insufficient selected-wallet funds; verify Cling Check explains the wallet shortfall and creates no expense.
2. Repeat with a purchase that consumes more than 25% of spendable balance; inspect the daily-allowance change and obligations list.
3. Try an account with mixed wallet currencies and with no payday configuration; verify the estimate is unavailable rather than summing currencies.
4. Add expenses across two comparable month-to-date periods; verify localized overall/category changes and open the Insight detail view.
5. Create/edit a goal plan, try changing target/date/frequency and simulated contribution, then leave without saving; verify persisted goal values remain unchanged.
6. Save the goal plan and add/delete contributions; verify historical contributions remain correct and wallet balance/expense statistics do not change.
7. Switch Firebase accounts and verify the prior account's Insights and goal plan never appear in the new account.
8. Restore a v4 backup and verify schema v5 planning columns appear with all ledger and goal history preserved.
