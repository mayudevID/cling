import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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

  Future<void> _edit([WalletModel? wallet]) async {
    final name = TextEditingController(text: wallet?.name ?? '');
    final balance = TextEditingController(
        text: wallet == null
            ? '0'
            : '${wallet.openingBalanceMinor ~/ 100}.${(wallet.openingBalanceMinor % 100).toString().padLeft(2, '0')}');
    var type = wallet?.type ?? 'cash';
    var makeDefault = wallet?.isDefault ?? false;
    final result = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  backgroundColor: const Color(0xFF252525),
                  title: Text(wallet == null ? 'Tambah wallet' : 'Edit wallet',
                      style: const TextStyle(color: Colors.white)),
                  content: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextField(
                        controller: name,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Nama')),
                    TextField(
                        controller: balance,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: const TextStyle(color: Colors.white),
                        decoration:
                            const InputDecoration(labelText: 'Saldo awal')),
                    DropdownButton<String>(
                        value: type,
                        dropdownColor: const Color(0xFF252525),
                        items: const [
                          DropdownMenuItem(value: 'bank', child: Text('Bank')),
                          DropdownMenuItem(
                              value: 'e-wallet', child: Text('E-Wallet')),
                          DropdownMenuItem(value: 'cash', child: Text('Cash')),
                          DropdownMenuItem(value: 'other', child: Text('Other'))
                        ],
                        onChanged: (v) => setState(() => type = v!)),
                    CheckboxListTile(
                        value: makeDefault,
                        title: const Text('Default wallet',
                            style: TextStyle(color: Colors.white)),
                        onChanged: (v) =>
                            setState(() => makeDefault = v ?? false)),
                  ])),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Batal')),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Simpan'))
                  ],
                )));
    if (result != true || !mounted) return;
    final minor = _minor(balance.text);
    if (name.text.trim().isEmpty || minor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama dan nominal saldo tidak valid')));
      return;
    }
    await _repo.saveWallet(WalletModel(
        id: wallet?.id,
        name: name.text,
        type: type,
        openingBalanceMinor: minor,
        currency: wallet?.currency ?? 'IDR',
        isArchived: wallet?.isArchived ?? false,
        isDefault: makeDefault));
    if (mounted) setState(_reload);
  }

  Future<void> _transfer(List<WalletModel> wallets) async {
    final active = wallets.where((w) => !w.isArchived).toList();
    if (active.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Buat minimal dua wallet aktif untuk transfer')));
      return;
    }
    final amount = TextEditingController();
    int source = active.first.id!, destination = active[1].id!;
    final note = TextEditingController();
    final ok = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  backgroundColor: const Color(0xFF252525),
                  title: const Text('Transfer',
                      style: TextStyle(color: Colors.white)),
                  content: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    DropdownButton<int>(
                        value: source,
                        items: active
                            .map((w) => DropdownMenuItem(
                                value: w.id, child: Text('Dari: ${w.name}')))
                            .toList(),
                        onChanged: (v) => setState(() {
                              source = v!;
                              if (source == destination)
                                destination = active
                                    .firstWhere((w) => w.id != source)
                                    .id!;
                            })),
                    DropdownButton<int>(
                        value: destination,
                        items: active
                            .where((w) => w.id != source)
                            .map((w) => DropdownMenuItem(
                                value: w.id, child: Text('Ke: ${w.name}')))
                            .toList(),
                        onChanged: (v) => setState(() => destination = v!)),
                    TextField(
                        controller: amount,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: const TextStyle(color: Colors.white),
                        decoration:
                            const InputDecoration(labelText: 'Nominal')),
                    TextField(
                        controller: note,
                        style: const TextStyle(color: Colors.white),
                        decoration:
                            const InputDecoration(labelText: 'Catatan')),
                  ])),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Batal')),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Transfer'))
                  ],
                )));
    if (ok != true || !mounted) return;
    final minor = _minor(amount.text);
    if (minor == null || minor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nominal harus lebih dari nol')));
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
          note: note.text);
    } finally {
      if (mounted)
        setState(() {
          _saving = false;
          _reload();
        });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
          backgroundColor: const Color(0xFF101010),
          title: const Text('Wallet')),
      body: FutureBuilder<List<WalletModel>>(
          future: _wallets,
          builder: (context, snap) {
            if (snap.hasError)
              return Center(
                  child: Text('Gagal memuat wallet: ${snap.error}',
                      style: const TextStyle(color: Colors.white)));
            if (!snap.hasData)
              return const Center(child: CircularProgressIndicator());
            final wallets = snap.data!;
            if (wallets.isEmpty)
              return const Center(
                  child: Text('Belum ada wallet',
                      style: TextStyle(color: Colors.white)));
            final currency = wallets.first.currency;
            final total = wallets
                .where((w) => !w.isArchived)
                .fold<int>(0, (sum, w) => sum + w.balanceMinor);
            return Column(children: [
              ListTile(
                  title: const Text('Total balance',
                      style: TextStyle(color: Colors.white)),
                  trailing: Text(
                      '$currency ${(total / 100).toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.pinkAccent))),
              Expanded(
                  child: ListView(
                      children: wallets
                          .map((w) => ListTile(
                              leading: const Icon(Icons.account_balance_wallet,
                                  color: Colors.pinkAccent),
                              title: Text(
                                  '${w.name}${w.isDefault ? ' • Default' : ''}',
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(
                                  '${w.type} · ${w.isArchived ? 'Archived' : 'Active'}',
                                  style:
                                      const TextStyle(color: Colors.white70)),
                              trailing: Wrap(spacing: 4, children: [
                                Text(
                                    '${w.currency} ${(w.balanceMinor / 100).toStringAsFixed(2)}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.white70),
                                    onPressed: () => _edit(w)),
                                if (!w.isArchived && !w.isDefault)
                                  IconButton(
                                      icon: const Icon(Icons.archive_outlined,
                                          color: Colors.white70),
                                      onPressed: () async {
                                        await _repo.archiveWallet(w.id!);
                                        if (mounted) setState(_reload);
                                      })
                              ]),
                              onTap: () => _edit(w)))
                          .toList())),
              Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    Expanded(
                        child: OutlinedButton(
                            onPressed:
                                _saving ? null : () => _transfer(wallets),
                            child: const Text('Transfer'))),
                    const SizedBox(width: 8),
                    Expanded(
                        child: FilledButton(
                            onPressed: _saving ? null : () => _edit(),
                            child: const Text('Tambah wallet')))
                  ])),
            ]);
          }));
}
