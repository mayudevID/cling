import 'dart:async';

import 'package:intl/intl.dart';

import '../../../../../core/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../../../../repository/settings_repository.dart';
import '../../../../../injection.dart';
import '../../main_widget/finance_refresh.dart';
import '../widget/dialog_logout.dart';
import 'package:timeago/timeago.dart' as timeago;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.profileContext});
  final BuildContext profileContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ProfileBloc>(profileContext),
      child: const SettingsPageContent(),
    );
  }
}

class SettingsPageContent extends StatelessWidget {
  const SettingsPageContent({super.key});

  void _message(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<bool> _confirm(
    BuildContext context,
    String title,
    String message,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Lanjutkan'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _afterRestore(BuildContext context) {
    if (!context.mounted) return;
    refreshFinancialViews(context);
    context.read<ProfileBloc>().add(GetProfile());
    _message(context, 'Cadangan berhasil dipulihkan.');
  }

  Future<void> _showCloudBackupHistory(BuildContext context) async {
    final repository = getIt<SettingsRepository>();
    try {
      final items = await repository.listCloudBackups();
      if (!context.mounted) return;
      if (items.isEmpty) {
        _message(context, 'Belum ada backup cloud untuk akun ini.');
        return;
      }
      final chosen = await showModalBottomSheet<CloudBackupRecord>(
        context: context,
        isScrollControlled: true,
        builder: (sheetContext) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Riwayat backup cloud'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 320,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(
                          DateFormat('dd MMM yyyy, HH:mm')
                              .format(item.sortAt.toLocal()),
                        ),
                        subtitle: Text(
                          item.manifest == null
                              ? 'Backup lama tanpa manifest'
                              : 'Snapshot tersimpan • Verifikasi SHA-256',
                        ),
                        onTap: () => Navigator.pop(sheetContext, item),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      if (chosen == null || !context.mounted) return;
      final proceed = await _confirm(
        context,
        'Pulihkan backup cloud?',
        'Data aktif akan diganti dengan snapshot terpilih. '
            'Salinan lokal akan disimpan sebelum restore. '
            'Backup cloud lain tidak akan dihapus.',
      );
      if (!proceed || !context.mounted) return;
      await repository.getBackup(
        storagePath: chosen.storagePath,
        allowOverwriteNewerLocal: true,
      );
      if (!context.mounted) return;
      _afterRestore(context);
    } catch (error) {
      _message(context, 'Gagal mengakses backup cloud: $error');
    }
  }

  Future<void> _showLocalRecovery(BuildContext context) async {
    final repository = getIt<SettingsRepository>();
    try {
      final items = await repository.listLocalRecoverySnapshots();
      if (!context.mounted) return;
      if (items.isEmpty) {
        _message(context, 'Belum ada snapshot pemulihan lokal.');
        return;
      }
      final chosen = await showModalBottomSheet<LocalRecoverySnapshot>(
        context: context,
        isScrollControlled: true,
        builder: (sheetContext) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Cadangan pemulihan lokal'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 320,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(
                          DateFormat('dd MMM yyyy, HH:mm')
                              .format(item.createdAt.toLocal()),
                        ),
                        subtitle: Text(
                          '${(item.sizeBytes / 1024).toStringAsFixed(1)} KB',
                        ),
                        onTap: () => Navigator.pop(sheetContext, item),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Hapus salinan',
                          onPressed: () async {
                            final proceed = await _confirm(
                              sheetContext,
                              'Hapus salinan pemulihan?',
                              'File ini akan dihapus secara permanen. '
                                  'Jangan hapus satu-satunya backup yang valid.',
                            );
                            if (!proceed) return;
                            await repository.deleteLocalRecoverySnapshot(
                              item.path,
                            );
                            if (sheetContext.mounted) {
                              Navigator.pop(sheetContext);
                            }
                            if (context.mounted) {
                              await _showLocalRecovery(context);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      if (chosen == null || !context.mounted) return;
      final proceed = await _confirm(
        context,
        'Pulihkan cadangan lokal?',
        'Database aktif akan diganti dengan salinan ini. '
            'Aplikasi akan menyimpan snapshot kondisi sekarang sebelum restore.',
      );
      if (!proceed || !context.mounted) return;
      await repository.restoreLocalRecoverySnapshot(
        chosen.path,
        allowOverwriteNewerLocal: true,
      );
      if (!context.mounted) return;
      _afterRestore(context);
    } catch (error) {
      _message(context, 'Gagal memulihkan cadangan lokal: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Assets
                          .lib.resources.images.fluentChevronLeft24Filled
                          .svg(),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      AppLocalizations.of(context)!.settings,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => showBottomSheetChooseLang(context),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Assets.lib.resources.images.globe.svg(),
                      const SizedBox(width: 10),
                      Text(
                        AppLocalizations.of(context)!.changeLanguage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Assets.lib.resources.images.chevronRight16.svg(),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  context.read<ProfileBloc>().state.version,
                  style: const TextStyle(
                    fontFamily: FontFamily.cabinetGrotesk,
                    color: Color.fromARGB(255, 189, 189, 189),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.lastBackup,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    BlocBuilder<ProfileBloc, ProfileState>(
                      buildWhen: (p, c) {
                        return p.userModel.lastBackupTime !=
                            c.userModel.lastBackupTime;
                      },
                      builder: (context, state) {
                        const textStyle = TextStyle(
                          color: Colors.white,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        );

                        if (state.userModel.lastBackupTime == null) {
                          return const Text(
                            "---",
                            style: textStyle,
                          );
                        }

                        return TimeBackup(
                          date: state.userModel.lastBackupTime!,
                          textStyle: textStyle,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 390,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<ProfileBloc>().add(GoBackup()),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        const Color(0x3D787880),
                      ),
                      overlayColor: WidgetStateProperty.all(Colors.white60),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.lib.resources.images.databaseBackup.svg(),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.backup,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.5,
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showCloudBackupHistory(context),
                    icon: const Icon(Icons.cloud_download_outlined),
                    label: const Text('Riwayat backup cloud'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showLocalRecovery(context),
                    icon: const Icon(Icons.restore_page_outlined),
                    label: const Text('Pemulihan backup lokal'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 390,
                  height: 57,
                  child: ElevatedButton(
                    onPressed: () => dialogLogout(context),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        const Color(0xFFF8312F),
                      ),
                      overlayColor: WidgetStateProperty.all(Colors.redAccent),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Logout",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeBackup extends StatefulWidget {
  const TimeBackup({super.key, required this.date, required this.textStyle});
  final DateTime date;
  final TextStyle textStyle;

  @override
  State<TimeBackup> createState() => _TimeBackupState();
}

class _TimeBackupState extends State<TimeBackup> {
  late Timer timer;

  @override
  void initState() {
    timeago.setLocaleMessages("id", timeago.IdMessages());

    Logger.Yellow.log(widget.date.toString());

    timer = Timer.periodic(const Duration(seconds: 12), (Timer t) {
      setState(() {});
      Logger.Yellow.log(widget.date.toString());
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.select(
      (LangCurrencyBloc bloc) => bloc.state.selectedLanguage.value.languageCode,
    );
    return Text(
      timeago.format(
        widget.date,
        locale: locale,
      ),
      style: widget.textStyle,
    );
  }
}
