class WalletModel {
  const WalletModel({
    this.id,
    required this.name,
    required this.type,
    required this.openingBalanceMinor,
    required this.currency,
    this.isArchived = false,
    this.isDefault = false,
    this.balanceMinor = 0,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String name;
  final String type;
  final int openingBalanceMinor;
  final String currency;
  final bool isArchived;
  final bool isDefault;
  final int balanceMinor;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory WalletModel.fromMap(Map<String, Object?> row) => WalletModel(
        id: row['wallet_id'] as int,
        name: row['name'] as String,
        type: row['type'] as String,
        openingBalanceMinor: row['opening_balance_minor'] as int,
        currency: row['currency'] as String,
        isArchived: row['is_archived'] == 1,
        isDefault: row['is_default'] == 1,
        balanceMinor: (row['balance_minor'] as int?) ?? 0,
        createdAt: DateTime.tryParse(row['created_at'] as String? ?? ''),
        updatedAt: DateTime.tryParse(row['updated_at'] as String? ?? ''),
      );
}
