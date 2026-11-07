/// SQLite can return the same legacy foreign key as int or numeric String,
/// depending on how the row was inserted. Never index a List with raw JSON.
int? parseReferenceId(Object? value) {
  if (value is int) return value;
  if (value is num && value.isFinite && value == value.truncateToDouble()) {
    return value.toInt();
  }
  if (value is String) return int.tryParse(value.trim());
  return null;
}

/// Preserve unknown IDs in the UI without crashing or silently relabeling
/// a transaction as a different source/category.
String displayReference(
  Object? value,
  List<String> labels, {
  required String unknownType,
}) {
  final id = parseReferenceId(value);
  if (id != null && id >= 0 && id < labels.length) return labels[id];
  return 'Unknown $unknownType (${value ?? "null"})';
}

/// All writes use a canonical INTEGER FK; malformed values are rejected
/// instead of introducing an orphan relationship.
int requireReferenceId(String encoded, List<String> labels) {
  final normalized = encoded.trim();
  // Database models carry a label; selection widgets may include a numeric
  // prefix. Both must round-trip to the identical primary key.
  final directIndex = labels.indexOf(normalized);
  if (directIndex >= 0) return directIndex;
  final token = normalized.split(RegExp(r'\s+')).first;
  final id = int.tryParse(token);
  if (id == null || id < 0 || id >= labels.length) {
    throw FormatException('Invalid reference ID: $encoded');
  }
  return id;
}
