import 'package:flutter/material.dart';

import '../features/model/wallet_model.dart';
import 'financial_feature_theme.dart';

class FinancialWalletSelector extends StatelessWidget {
  const FinancialWalletSelector({
    super.key,
    required this.wallets,
    required this.selectedWalletId,
    required this.label,
    required this.onChanged,
  });

  final List<WalletModel> wallets;
  final int? selectedWalletId;
  final String label;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) => FinancialFeatureTheme(
        child: DropdownButtonFormField<int>(
          initialValue: wallets.any((wallet) => wallet.id == selectedWalletId)
              ? selectedWalletId
              : null,
          isExpanded: true,
          decoration: InputDecoration(labelText: label),
          items: wallets
              .map(
                (wallet) => DropdownMenuItem<int>(
                  value: wallet.id,
                  child: Text(wallet.name, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      );
}
