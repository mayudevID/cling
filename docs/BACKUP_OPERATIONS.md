# Backup safety, Firebase Storage access, and recovery

Cling keeps monetary records in a SQLite file **per Firebase UID**. Local
files are not automatically synchronized across devices.

## Cloud backups: immutable versions

New uploads use `backupDb/<uid>/snapshots/<microseconds>_<digest>.db` and
include metadata for the owner UID, schema version, snapshot start time,
SHA-256, and last financial modification time read **from the snapshot**.
Each upload uses a new object name; no device overwrites an earlier backup.

The Settings screen lists cloud backup history. The automatic login restore
prefers the version with the latest known financial modification time; when
metadata is missing, it falls back to snapshot/upload time. **This is not
merging or conflict resolution**: a newer timestamp doesn't guarantee the
backup contains every transaction made on every device. Check the available
history before replacing live data.

Old `backupDb/<uid>.db` objects remain readable and are not overwritten.

### Required Firebase Storage Security Rules deployment

Rules are configured in the Firebase project, not by uploading Dart code.
The deployed rules **must allow listing and creating** the per-user snapshot
paths; legacy per-user backup objects can be read but should be read-only.

An illustrative, minimal rule fragment (merge with your existing rules;
verify in the Storage emulator before deploying):

```js
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /backupDb/{uid}/snapshots/{fileName} {
      allow get, list: if request.auth != null && request.auth.uid == uid;
      allow create: if request.auth != null
        && request.auth.uid == uid
        && request.resource.size < 20 * 1024 * 1024;
      allow update, delete: if false;
    }
    match /backupDb/{fileName} {
      allow get: if request.auth != null
        && fileName == request.auth.uid + '.db';
      allow write: if false;
    }
  }
}
```

Your Firebase project may already have additional rules; do **not** replace
them indiscriminately. Listing many cloud snapshots has a read/metadata cost.
Define a retention/archiving plan before production rollout.

## Restore and local recovery

- A manifest SHA-256 is checked *before* a cloud backup is activated.
- The source snapshot is validated for SQLite integrity, schema version,
  required tables, and required columns.
- Snapshot capture time is recorded **before** the SQLite snapshot is made,
  preventing a later metadata timestamp from understating its age.
- When the local data may be newer, the app requires an explicit confirmation.
- Before replacing the live database, the previous content is preserved in
  a separate `.before_restore_<timestamp>.db` file.
- The Settings screen allows users to list, restore, and explicitly delete
  these recovery copies. This is user-controlled retention: Cling does not
  silently remove the only recovery copy.
- Local databases and these snapshots are **not separately encrypted**.
  Restrict device backup/file access and consider encryption at rest.

For migrations, legacy database files remain available for manual recovery.

## Firebase Auth and profile recovery

When Firebase Authentication succeeds but Firestore profile creation was
interrupted, login initializes **only the missing** profile fields in an
idempotent Firestore transaction. Existing budget/income and identity fields
are never reset. A pending registration currency is cached per UID to
recover from a partial sign-up.

If Firestore is temporarily unavailable and the Firebase UID has a matching
cached profile, login can proceed with *existing local data* without
generating recurring income from stale settings. The stored Firebase Auth
session may also be reused offline for the same identity. This is not
offline password authentication: a signed-out device still needs Firebase
authentication/network access for a new sign-in.

## Regression checks before release

```sh
flutter pub get
flutter analyze --no-fatal-infos
flutter test
```

Manually verify multi-device snapshot creation, old legacy backup recovery,
snapshot restore rollback on network/disk failure, UID changes mid-restore,
cloud listing security rules and permission failures, and local snapshot
restore/delete. Test on copies of real finances, not the only original.

Check SQLite integrity after migration:

```sql
PRAGMA foreign_keys;
PRAGMA foreign_key_check;
PRAGMA integrity_check;
```

Existing legacy orphan records should be audited and repaired deliberately,
not silently deleted.
