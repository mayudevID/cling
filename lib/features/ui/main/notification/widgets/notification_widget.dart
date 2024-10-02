import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/notification_bloc.dart';

Widget notificationWidget(int idx) {
  String title = "";
  String desc = "";

  //* TYPE 0: warning monthly budget
  //* TYPE 1: warning current balance this month
  //* TYPE 2: warning total balance

  bool isNeedDateContext = false;

  String checkConditionText(String formatT, DateTime dateTime) {
    return (isNeedDateContext)
        ? '( ${DateFormat.yMMMM(formatT).format(dateTime)} )'
        : "";
  }

  return BlocBuilder<NotificationBloc, NotificationState>(
    buildWhen: (p, c) {
      return p.listNotif[idx].isRead != c.listNotif[idx].isRead;
    },
    builder: (context, state) {
      final timeLocale = context
          .read<LangCurrencyBloc>()
          .state
          .selectedLanguage
          .value
          .toLanguageTag();

      final appLoc = AppLocalizations.of(context)!;

      if (state.listNotif[idx].type == 0) {
        title = appLoc.alertMonthlyBudget;
        desc = appLoc.warningMonthlyBudget;
        isNeedDateContext = true;
      } else if (state.listNotif[idx].type == 1) {
        title = appLoc.alertCurrentBalance;
        desc = appLoc.warningCurrentBalance;
        isNeedDateContext = true;
      } else {
        title = appLoc.alertTotalBalance;
        desc = appLoc.warningTotalBalance;
      }

      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(16),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: (state.listNotif[idx].isRead)
              ? const Color(0x3D787880)
              : Colors.blueGrey[700],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.lib.resources.images.warningTriangleSolid
                    .svg(width: 40.w),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 5,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat.jm(timeLocale).format(
                              state.listNotif[idx].date,
                            ),
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w200,
                              fontSize: 8.5.sp,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$desc ${checkConditionText(timeLocale, state.listNotif[idx].date)}',
                        maxLines: 5,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: FontFamily.cabinetGrotesk,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            (state.listNotif[idx].isRead)
                ? const SizedBox()
                : Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        context.read<NotificationBloc>().add(
                              MarkNotificationRead(
                                idx,
                                state.listNotif[idx],
                              ),
                            );
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: FontFamily.cabinetGrotesk,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      );
    },
  );
}
