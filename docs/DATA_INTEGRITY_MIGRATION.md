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

## Integrity hardening (schema v2 compatible)

### Test toolchain

Use `sqflite_common_ffi >=2.3.7 <2.4.0` to avoid the breaking
`sqlite3/open.dart` import caused by mixing older sqflite FFI with
sqlite3 v3. The Flutter runner must have Dart >=3.9 for this version.

### Recurring income

- Database open now creates/migrates schema but **does not** generate
  recurring salary from stale device settings.
- A successful login, or a cold start with server connectivity, fetches
  the current account settings from Firestore and then reconciles the
  SQLite recurring rule. When offline, keep existing transactions
  available without generating an unverified recurring payment.
- Legacy recurring entries that match the original description and
  source are used to populate the rule/month occurrence ledger before
  the scheduler can generate new entries. This is conservative and does
  not erase existing transactions; users should review historical
  duplicate salary entries manually.
- Disabling a recurring rule retains the rule identity and its payment
  occurrence history, so a payday change cannot generate two records
  for a month that is already marked as paid.

### Settings synchronization

- Firestore is the desired state. After a successful remote change,
  an account-specific `pending_monthly_settings_<uid>` marker survives
  interrupted local writes. Startup/login fetches fresh server values,
  reconciles local recurring configuration, and clears the marker.
- Firestore and SQLite are **not** a distributed transaction. When
  the network is unavailable, local salary generation waits until the
  server can be reconciled; users can still view existing device data.
- Login/startup reconciliation runs only with a matching active
  authenticated UID and database. A change of account invalidates
  in-flight processing.

### Restore and backup protection

- New Firebase Storage SQLite backups include object metadata for
  owner UID, SQLite schema version, UTC snapshot time, and SHA-256.
- Restore verifies SQLite integrity, required tables and columns,
  supported schema version (v1/v2), optional legacy/new manifest,
  owner UID, and SHA-256 before swapping the active file.
- A newer local financial modification timestamp triggers a **second
  explicit confirmation**. Backups without modern manifest metadata
  also require confirmation if there are existing local transactions.
- The previous local database is snapshotted to a unique
  `.before_restore_<timestamp>.db` path before replacement. This
  recovery copy is **not** deleted on success and is not encrypted
  separately from the local SQLite database; apply the same device
  security/privacy controls. Avoid indefinitely accumulating these
  copies in production: provide a deliberate recovery/retention UX.
- The short-lived `.rollback` file protects failed/interrupted
  replacement. The pre-restore snapshot protects against *successful*
  restores replacing more recent local data.
- Never directly restore a mismatched or malformed manifest, even
  if the SQLite file itself passes integrity_check.

### Database and onboarding lifecycle

- Concurrent database-open requests share the same future; an
  initialization exception closes its partial handle and does not
  mark an account as ready. An open may be retried.
- Nonempty databases track the last change to income, expenses,
  savings goals and savings history through SQLite triggers.
- Monthly onboarding state is immutable and its text controller is
  owned/disposed by the page. Navigating backward preserves in-progress
  budget input without mutating Equatable state.

### Release verification

```bash
flutter pub get
dart format lib test
flutter analyze --no-fatal-infos
flutter test
```

Test additionally: offline startup on payday, switching UID mid-restore,
restoring an old v1 backup and a tampered checksum, saving settings while
offline or with a forced local write failure, and restoring newer versus
older local data. Never deploy on the only copy of actual finance records
without a separate verified backup.

