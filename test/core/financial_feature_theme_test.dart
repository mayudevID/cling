import 'package:cling/core/financial_feature_theme.dart';
import 'package:cling/core/financial_wallet_selector.dart';
import 'package:cling/features/model/wallet_model.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('financial feature theme keeps fields readable on a narrow view',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: FinancialFeatureTheme(
          child: Scaffold(
            appBar: AppBar(title: const Text('Wallet')),
            body: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(labelText: 'Wallet name'),
              ),
            ),
          ),
        ),
      ),
    );

    final fieldContext = tester.element(find.byType(TextField));
    final theme = Theme.of(fieldContext);
    expect(theme.textTheme.bodyMedium?.fontFamily, FontFamily.cabinetGrotesk);
    expect(theme.inputDecorationTheme.fillColor, FinancialFeatureTheme.field);
    expect(tester.getSize(find.byType(TextField)).width, 280);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wallet selector handles long names and keeps selection changes',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var selectedId = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: StatefulBuilder(
              builder: (context, setState) => FinancialWalletSelector(
                wallets: const [
                  WalletModel(
                    id: 1,
                    name: 'A very long wallet name for a narrow mobile screen',
                    type: 'bank',
                    openingBalanceMinor: 0,
                    currency: 'IDR',
                  ),
                  WalletModel(
                    id: 2,
                    name: 'Savings',
                    type: 'bank',
                    openingBalanceMinor: 0,
                    currency: 'IDR',
                  ),
                ],
                selectedWalletId: selectedId,
                label: 'Wallet',
                onChanged: (value) => setState(() => selectedId = value!),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Savings').last);
    await tester.pumpAndSettle();

    expect(selectedId, 2);
    expect(tester.takeException(), isNull);
  });
}
