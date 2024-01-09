import 'dart:async';

import 'package:cling/core/logger.dart';
import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../../profile/bloc/profile_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.wmea),
          child: Column(
            children: [
              SizedBox(height: 16.hmea),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Assets.lib.resources.images.fluentChevronLeft24Filled
                        .svg(),
                  ),
                  SizedBox(width: 16.wmea),
                  Text(
                    AppLocalizations.of(context)!.settings,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              SizedBox(height: 24.hmea),
              GestureDetector(
                onTap: () => showBottomSheetChooseLang(context),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 8.wmea),
                    Assets.lib.resources.images.globe.svg(),
                    SizedBox(width: 10.wmea),
                    Text(
                      AppLocalizations.of(context)!.changeLanguage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Assets.lib.resources.images.chevronRight16.svg(),
                    SizedBox(width: 8.wmea),
                  ],
                ),
              ),
              SizedBox(height: 48.hmea),
              Text(
                context.read<ProfileBloc>().state.version,
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  color: const Color.fromARGB(255, 189, 189, 189),
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.hmea),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.wmea),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.lastBackup,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    BlocBuilder<ProfileBloc, ProfileState>(
                      buildWhen: (p, c) {
                        return p.userModel.lastBackupTime !=
                            c.userModel.lastBackupTime;
                      },
                      builder: (context, state) {
                        final textStyle = TextStyle(
                          color: Colors.white,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w500,
                        );

                        if (state.userModel.lastBackupTime == null) {
                          return Text(
                            "---",
                            style: textStyle,
                          );
                        }

                        return TimeBackup(
                          date: state.userModel.lastBackupTime!,
                          textStyle: textStyle,
                        );
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.hmea),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.wmea),
                child: SizedBox(
                  width: 390.wmea,
                  height: 45.hmea,
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<ProfileBloc>().add(GoBackup()),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color(0x3D787880),
                      ),
                      overlayColor: MaterialStateProperty.all(Colors.white60),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.lib.resources.images.databaseBackup.svg(),
                        SizedBox(width: 8.wmea),
                        Text(
                          AppLocalizations.of(context)!.backup,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.5.sp,
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.hmea),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.wmea),
                child: SizedBox(
                  width: 390.wmea,
                  height: 57.hmea,
                  child: ElevatedButton(
                    onPressed: () => dialogLogout(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color(0xFFF8312F),
                      ),
                      overlayColor: MaterialStateProperty.all(Colors.redAccent),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Text(
                      "Logout",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.5.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
