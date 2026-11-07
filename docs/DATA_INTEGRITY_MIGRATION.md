# Cling! data integrity and v2 migration

## Important release note

This change introduces **SQLite schema v2**, canonical integer monetary values
in hundredths of the account's selected currency, and one local database per
Firebase UID. Verify backup and recovery on a **copy of an existing device**
before shipping this migration. Do not downgrade a v2 database using the
previous binary.

## Safety model

- Existing version-1 monetary columns remain in place for compatibility.
  The migration adds `*_minor` integer columns and backfills them with
  `ROUND(legacy_value * 100)`. New writes update both representations;
  financial summaries and model reads use the canonical integer columns.
- When an authenticated Firebase UID matches the UID in the cached profile,
  the old `cling_database.db` is snapshotted once to
  `cling_database_<uid>.db`. The legacy file is **not deleted**.
- When there is no authenticated matching cached UID, legacy data is
  deliberately **not assigned to any new user**. Keep the old file for
  manual recovery; do not infer its owner.
- Guest data resides in `cling_guest.db` and is not exposed as another
  account's data. Logout switches to guest without deleting an account DB.
- Cloud backups continue using `backupDb/<uid>.db`. The backup is an
  SQLite-consistent snapshot created using `VACUUM INTO`. On devices whose
  SQLite does not support this statement, backup fails safely rather than
  uploading an inconsistent live-file copy.
- Restore downloads to a separate file, checks `PRAGMA integrity_check`
  and required tables, then closes SQLite and swaps the file. The old file
  is retained as `.rollback` until the restored database opens successfully.
  If the app is interrupted mid-restore, the next open recovers the rollback.
- Per-account SQLite files are device-local, not real-time cross-device sync.

## Recurring income

- The active rule for each (type, model) is updated rather than appended on
  every login. Duplicate legacy rules are discarded without deleting
  historical income transactions.
- Each generated month is protected by an occurrence key and its insertion
  and progress marker are committed in one SQLite transaction.
- Dates are calendar-aware. A payday on the 31st is clamped to the end of
  shorter months.
- This change cannot reliably distinguish legitimate historic entries from
  previously duplicated recurring entries. **Do not auto-delete historic
  income** without user review.

## Savings goals

- Contributions and deletions are atomic SQLite transactions.
- The collected amount is updated with a database-side constraint, not
  independently from a stale BLoC state.
- Savings goals remain tracking-only: they do not automatically transfer
  funds from the main cash balance.

## Verification checklist

Run in a Flutter-enabled environment:

```bash
flutter pub get
dart format lib test
flutter analyze
flutter test
```

Manually exercise upgrade from a **copy** of a real v1 database, login with
two different accounts on one phone, logout while not backed up, failed
network restore, successful cloud restore, edits to old transactions, and
opening the app across month boundaries. Confirm that the Firebase Storage
rules limit each backup path to its matching authenticated UID.

## Limitations and follow-up

- A version-1 database without an authenticated matching cached UID is left
  untouched for recovery, rather than imported into an unverified account.
- The Firestore monthly income and budget fields still use their legacy
  representation. The integer migration here covers **local SQLite monetary
  transactions, savings, and recurring rules**.
- Full BLoC/UI lifecycle decoupling is a separate refactor. This change
  addresses database startup readiness, a subset of immutable states,
  operation sequencing, and reloading active views after account switches.
- The tests use `sqflite_common_ffi` and must be executed in a compatible
  Flutter/Dart development environment; no CI/device results are implied.

## Follow-up patch: transaction correctness and UI projection consistency

- Editing an income/expense now writes both the legacy major-unit amount and
  the canonical integer `amount_minor` in one row update.
- Authenticated app state is permitted only when Firebase UID, cached profile
  UID, active SQLite owner UID, and database readiness all agree. A Firebase
  auth event by itself is not sufficient to open the finance dashboard.
- Goals and notifications use deterministic keyset paging. Notifications are
  ordered by the full ISO timestamp plus ID, with a supporting index. The
  page-size boundary and one-record cases are regression-tested.
- Finance notifications use localized copy and an atomic once-per-period
  check. A missing (zero) budget never triggers a budget-exceeded warning.
- Updating monthly income/recurring day immediately synchronizes its local
  schedule. The disabled rule keeps its identity and occurrence ledger so
  re-enabling it in the same month does not generate a second payment.
- Transaction mutations refresh Home, selected-month transaction history,
  statistics and any active category detail page from SQLite. Async result
  handling checks active account revisions and request identity.
- GitHub Actions now executes `flutter analyze` and `flutter test` for
  main-branch pushes and pull requests.

### Release smoke tests

1. Edit income and expense amounts, restart the app, and compare transaction
   values, Home balance and graph totals.
2. Open an existing account, log out, sign into another UID and confirm no
   records from the previous account are shown. Repeat with app restart.
3. Open Goals with one item, then 12, 13 and 25; scroll through each page.
   Repeat with notifications containing equal timestamps.
4. Leave budget at zero, add an expense, and confirm no budget-exceeded
   notification is created. Set a budget and exceed it.
5. Change or disable monthly income, then re-enable it on payday; verify no
   second income transaction is inserted for the same month.
6. Switch transaction months rapidly and edit a transaction's date/category
   while viewing filtered statistics.

**Note:** Unit tests and static analysis must run in a Flutter-equipped
environment or GitHub Actions. This repository patch itself was prepared via
GitHub APIs without executing an Android/iOS build.
