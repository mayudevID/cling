# Phase 2 Financial Planning

## Architecture and storage

Financial planning is device-local and belongs to the active Firebase UID's SQLite database, like the existing ledger. `DatabaseRepository` owns writes and projections; `PlanningBloc` loads and refreshes them; the Planning screens provide the user flow. Schema v4 adds recurring expense rules (`recurring_expenses`), dated occurrence snapshots (`recurring_expense_occurrences`), bills (`bills`), key/value planning preferences (`financial_planning_settings`), and idempotency markers for local inbox reminders (`planning_reminder_deliveries`). Existing rows are not rewritten by this migration. v1/v2/v3 backups continue through the existing integrity and ownership checks and are upgraded by SQLite on open.

Recurring rules and occurrences are separate. Occurrences have a unique `(rule_id, scheduled_date)` key and snapshot their amount, category, and wallet so later rule edits do not rewrite already generated obligations. Weekly scheduling uses ISO weekday numbers (Monday=1 through Sunday=7). Monthly dates 29–31 clamp to the last calendar day. Reconciliation runs transactionally on app startup/resume and Planning refresh. Automatic posting is an assumed payment and is never represented as a verified bank transaction. Manual occurrences are confirmed before an expense is written.

## Bills and accounting

An unpaid bill is a planning record only. It does not create an expense or affect wallet balances/statistics. Payment atomically inserts one expense and sets the bill's unique expense reference; retries return the existing expense. Existing expenses can be linked manually from amount/category/date-matching candidates. If a linked expense is deleted, SQLite clears the bill link and the bill becomes unpaid again. Recurring occurrences are exposed as obligations in the Recurring Expenses section; one-time bills are managed in Bills.

Reminder preferences are per bill (3 days, 1 day, and due date). Reconciliation writes each reminder identity once to the existing local notification inbox. Device-level scheduled notifications and background execution are not implemented; reminders are delivered when the app is opened/resumed/reconciled.

## Payday Runway rules

The planning payday setting takes precedence; otherwise a valid monthly recurring income day is reused. The next payday is strictly after the current local calendar date; the day count is the difference between date-only values. Configuring a payday on the current day therefore targets the next cycle. All active wallet balances are included only when they share one currency. Bills and recurring obligations before the next payday are deducted, and a recurring obligation already represented by a bill is counted once. A mixed-currency wallet/obligation set produces an unavailable projection instead of summing unlike minor units. Archived wallet balances are excluded; the UI includes their names in the projection breakdown. Expected income is displayed separately and never included in available cash. The safety reserve is a non-negative integer minor-unit preference. Negative spendable cash is shown as a shortfall; only daily allowance is clamped to zero.

All canonical amounts remain integer minor units (factor 100). The app does not convert currencies. Changing the account's display currency does not reinterpret stored money.

## Limitations and release checks

- Reminders are in-app inbox entries and require the app to run; this is not a background notification guarantee.
- Automatic recurring expense posting represents an assumed payment. Users should choose manual confirmation when the date/amount is uncertain.
- Recurring obligations are managed through recurring occurrences, not materialized as Bill rows. One-time bills have the bill payment/link lifecycle.
- Runway is an estimate. It does not include unconfigured future income and is unavailable when included obligations use a different currency from active balances.
- Wallets with different currencies are not converted or aggregated.

Manual smoke tests before release:

1. Create a bill, restart the app, pay it, restart again, and verify exactly one expense and one wallet balance change.
2. Link an already recorded expense to an unpaid bill and verify the ledger does not change again; delete that expense and verify the bill returns to unpaid.
3. Create and edit weekly/monthly recurring expenses, pause/resume a rule, and reopen after several missed dates; verify one occurrence per scheduled date and no duplicate automatic expenses.
4. Change the planning payday and reserve; verify the period and breakdown recalculate without changing historical transactions.
5. Switch Firebase accounts and verify each account's bills and rules remain isolated.
6. Restore a legacy backup and a current backup and verify ledger integrity and UID ownership checks.
7. Open the app offline and verify local planning records/reminders remain available.

Tests cover calendar boundaries, v2/v3 migrations, legacy backup acceptance, UID isolation, idempotent expense payment, reminder markers, recurrence reconciliation, and runway arithmetic. Run `fvm flutter test` and `fvm flutter analyze` for current validation; analyzer info-level lint findings are tracked separately from compilation errors.
