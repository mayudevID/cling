import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/financial_feature_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../model/wallet_model.dart';
import '../../../repository/database_repository.dart';

class WalletsPage extends StatefulWidget {
  const WalletsPage({super.key});

  @override
  State<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  final _repo = GetIt.I<DatabaseRepository>();
  late Future<List<WalletModel>> _wallets;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() => _wallets = _repo.getWallets();

  int? _minor(String input) {
    final value = input.trim().replaceAll(',', '.');
    final match = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(value);
    if (match == null) return null;
    return int.parse(match[1]!) * 100 +
        int.parse((match[2] ?? '').padRight(2, '0'));
  }

  String _money(BuildContext context, int minor, String currency) =>
      NumberFormat.currency(
        locale: Localizations.localeOf(context).toString(),
        name: currency,
      ).format(minor / 100);

  Future<void> _edit([WalletModel? wallet]) async {
    final l10n = AppLocalizations.of(context)!;
    final name = TextEditingController(text: wallet?.name ?? '');
    final balance = TextEditingController(
      text: wallet == null
          ? '0'
          : '${wallet.openingBalanceMinor ~/ 100}.${(wallet.openingBalanceMinor % 100).toString().padLeft(2, '0')}',
    );
    var type = wallet?.type ?? 'cash';
    var makeDefault = wallet?.isDefault ?? false;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Theme(
        data: FinancialFeatureTheme.of(dialogContext),
        child: StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(wallet == null ? l10n.walletAdd : l10n.walletEdit),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: name,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: l10n.walletName),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: balance,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.walletOpeningBalance,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: type,
                    decoration: InputDecoration(labelText: l10n.wallet),
                    items: [
                      DropdownMenuItem(
                        value: 'cash',
                        child: Text(l10n.walletTypeCash),
                      ),
                      DropdownMenuItem(
                        value: 'bank',
                        child: Text(l10n.walletTypeBank),
                      ),
                      DropdownMenuItem(
                        value: 'e-wallet',
                        child: Text(l10n.walletTypeEwallet),
                      ),
                      DropdownMenuItem(
                        value: 'other',
                        child: Text(l10n.walletTypeOther),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setDialogState(() => type = value);
                    },
                  ),
                  const SizedBox(height: 4),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: makeDefault,
                    title: Text(l10n.walletDefault),
                    activeColor: FinancialFeatureTheme.accent,
                    onChanged: (value) => setDialogState(
                      () => makeDefault = value ?? false,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
    if (result != true || !mounted) return;
    final minor = _minor(balance.text);
    if (name.text.trim().isEmpty || minor == null) {
      _message(l10n.walletInvalidNameBalance);
      return;
    }
    await _repo.saveWallet(
      WalletModel(
        id: wallet?.id,
        name: name.text,
        type: type,
        openingBalanceMinor: minor,
        currency: wallet?.currency ?? 'IDR',
        isArchived: wallet?.isArchived ?? false,
        isDefault: makeDefault,
      ),
    );
    if (mounted) setState(_reload);
  }

  Future<void> _transfer(List<WalletModel> wallets) async {
    final l10n = AppLocalizations.of(context)!;
    final active = wallets.where((wallet) => !wallet.isArchived).toList();
    if (active.length < 2) {
      _message(l10n.walletCreateTwoForTransfer);
      return;
    }
    final amount = TextEditingController();
    final note = TextEditingController();
    var source = active.first.id!;
    var destination = active[1].id!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Theme(
        data: FinancialFeatureTheme.of(dialogContext),
        child: StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(l10n.walletTransferButton),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: source,
                    decoration:
                        InputDecoration(labelText: l10n.walletTransferFrom),
                    items: active
                        .map(
                          (wallet) => DropdownMenuItem(
                            value: wallet.id,
                            child: Text(
                              wallet.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setDialogState(() {
                        source = value;
                        if (source == destination) {
                          destination = active
                              .firstWhere((wallet) => wallet.id != source)
                              .id!;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: destination,
                    decoration:
                        InputDecoration(labelText: l10n.walletTransferTo),
                    items: active
                        .where((wallet) => wallet.id != source)
                        .map(
                          (wallet) => DropdownMenuItem(
                            value: wallet.id,
                            child: Text(
                              wallet.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => destination = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.walletTransferAmount,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: note,
                    decoration: InputDecoration(
                      labelText: l10n.walletTransferNote,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.swap_horiz),
                label: Text(l10n.walletTransferButton),
              ),
            ],
          ),
        ),
      ),
    );
    if (ok != true || !mounted) return;
    final minor = _minor(amount.text);
    if (minor == null || minor <= 0) {
      _message(l10n.walletTransferAmountPositive);
      return;
    }
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await _repo.transfer(
        sourceWalletId: source,
        destinationWalletId: destination,
        amountMinor: minor,
        date: DateTime.now(),
        note: note.text,
      );
    } catch (error) {
      if (mounted) _message('$error');
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
          _reload();
        });
      }
    }
  }

  Future<void> _archive(WalletModel wallet) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Theme(
        data: FinancialFeatureTheme.of(dialogContext),
        child: AlertDialog(
          title: Text(l10n.walletArchiveTitle),
          content: Text(l10n.walletArchiveDescription),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.walletArchiveAction),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await _repo.archiveWallet(wallet.id!);
      if (mounted) setState(_reload);
    } catch (error) {
      if (mounted) _message('$error');
    }
  }

  void _message(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FinancialFeatureTheme(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.wallet)),
        body: FutureBuilder<List<WalletModel>>(
          future: _wallets,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.walletLoadError, textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => setState(_reload),
                        child: Text(l10n.walletRetry),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: FinancialFeatureTheme.accent,
                ),
              );
            }
            final wallets = snapshot.requireData;
            final active =
                wallets.where((wallet) => !wallet.isArchived).toList();
            final currency = active.isNotEmpty
                ? active.first.currency
                : wallets.isNotEmpty
                    ? wallets.first.currency
                    : 'IDR';
            final total = active.fold<int>(
              0,
              (sum, wallet) => sum + wallet.balanceMinor,
            );
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                _summaryCard(
                  context,
                  l10n.walletTotalBalance,
                  _money(context, total, currency),
                  wallets.length,
                ),
                const SizedBox(height: 20),
                if (wallets.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 34,
                          color: Colors.white38,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.walletEmpty,
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ...wallets.map(
                    (wallet) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _walletCard(context, wallet, l10n),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _saving ? null : () => _transfer(wallets),
                        icon: const Icon(Icons.swap_horiz),
                        label: Text(l10n.walletTransferButton),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _saving ? null : () => _edit(),
                        icon: const Icon(Icons.add),
                        label: Text(l10n.walletAdd),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _summaryCard(
    BuildContext context,
    String title,
    String amount,
    int walletCount,
  ) =>
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: FinancialFeatureTheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Text(
              amount,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.walletCount(walletCount),
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      );

  Widget _walletCard(
    BuildContext context,
    WalletModel wallet,
    AppLocalizations l10n,
  ) {
    final archived = wallet.isArchived;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      decoration: BoxDecoration(
        color: FinancialFeatureTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: wallet.isDefault
            ? Border.all(
                color: FinancialFeatureTheme.accent.withValues(alpha: 0.55),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: archived ? Colors.white38 : FinancialFeatureTheme.accent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wallet.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: archived ? Colors.white60 : Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 6,
                      runSpacing: 5,
                      children: [
                        _statePill(
                          wallet.isDefault
                              ? l10n.walletDefault
                              : _walletTypeLabel(l10n, wallet.type),
                          wallet.isDefault
                              ? FinancialFeatureTheme.accent
                              : Colors.white24,
                        ),
                        _statePill(
                          archived ? l10n.walletArchived : l10n.walletActive,
                          archived ? Colors.white24 : const Color(0xFF28633B),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.walletEdit,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.edit_outlined, color: Colors.white70),
                onPressed: () => _edit(wallet),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  _money(context, wallet.balanceMinor, wallet.currency),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: archived ? Colors.white60 : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (!archived && !wallet.isDefault)
                TextButton.icon(
                  onPressed: () => _archive(wallet),
                  icon: const Icon(Icons.archive_outlined, size: 18),
                  label: Text(l10n.walletArchiveAction),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statePill(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                color == FinancialFeatureTheme.accent ? color : Colors.white70,
            fontSize: 11,
          ),
        ),
      );

  String _walletTypeLabel(AppLocalizations l10n, String type) => switch (type) {
        'bank' => l10n.walletTypeBank,
        'e-wallet' => l10n.walletTypeEwallet,
        'cash' => l10n.walletTypeCash,
        _ => l10n.walletTypeOther,
      };
}
