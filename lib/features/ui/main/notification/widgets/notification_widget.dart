import 'package:cling/core/utils.dart';
import 'package:cling/features/model/notification_model_class.dart';
import 'package:cling/features/ui/language_currency/lang_currency_bloc.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:cling/features/ui/main/notification/bloc/notification_bloc.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

Widget notificationWidget(
    BuildContext context, int idx, NotificationModelClass data) {
  String title = "";
  String desc = "";
  final timeLocale = context
      .read<LangCurrencyBloc>()
      .state
      .selectedLanguage
      .value
      .toLanguageTag();

  if (data.type == 0) {
    title = AppLocalizations.of(context)!.alert;
    desc = AppLocalizations.of(context)!.warningMonthlyBudget;
  }

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0x3D787880),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Assets.lib.resources.images.warningTriangleSolid
                .svg(width: 40.wmea),
            SizedBox(width: 16.wmea),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat.jm(timeLocale).format(data.date),
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    desc,
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
        BlocBuilder<NotificationBloc, NotificationState>(
          buildWhen: (p, c) {
            return p.listNotif[idx] != c.listNotif[idx];
          },
          builder: (context, state) {
            if (state.listNotif[idx].isRead) {
              return const SizedBox();
            }

            return Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () async {
                  context
                      .read<NotificationBloc>()
                      .add(MarkNotificationRead(idx, data));
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.blue[100],
                    fontFamily: FontFamily.cabinetGrotesk,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}
