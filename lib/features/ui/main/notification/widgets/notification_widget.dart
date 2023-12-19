import 'package:cling/core/utils.dart';
import 'package:cling/features/model/notification_model_class.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

Widget notificationWidget(BuildContext context, NotificationModelClass data) {
  String title = "";
  String desc = "";

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
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Assets.lib.resources.images.warningTriangleSolid.svg(width: 40.wmea),
        SizedBox(width: 16.wmea),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                desc,
                maxLines: 5,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.cabinetGrotesk,
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}
