# Phase 1 Financial Foundation

Schema v3 adds `wallets`, `wallet_transfers`, and `quick_transaction_templates`. Income and expense rows gain `wallet_id`; v1 and v2 rows migrate to the Cash wallet (ID 1), opening balance zero, preserving `amount_minor`. SQLite runs `onUpgrade` transactionally and the repository is marked ready only after open-time setup succeeds. Restore validates legacy v1/v2 and current v3 snapshots, then the normal database open path migrates them. UID-specific filenames and existing checksum, manifest, rollback and newer-local confirmation remain in place.

Wallet balances are projections: opening balance + income - expense + incoming transfers - outgoing transfers. Transfers are separate records and do not enter income/expense statistics. Savings goals remain tracking-only. Wallet currency is stored per wallet; this implementation uses IDR as the creation default and does not perform exchange conversion. Existing account currency remains a display preference and must not be treated as a conversion.

## Current implementation status

Implemented: schema migration and legacy wallet assignment, wallet model and balance projection, wallet CRUD/archive/default selection, transfer creation and wallet list UI, income/expense model wallet references and wallet selection in add/edit forms, and legacy/current backup validation through schema v4.

Remaining before release: wallet-labelled transaction history and filters, transfer editing/deletion and duplicate-submit keying, Quick Add template CRUD/confirmation flow, and transfer-specific interaction polish. The schema for Quick Add templates exists but the application flow is not implemented.

No database downgrade is supported. Rollback means restoring the pre-upgrade per-UID SQLite snapshot; do not open a v3 database in an older app after making new wallet/transfer writes, because older versions cannot represent those records.
