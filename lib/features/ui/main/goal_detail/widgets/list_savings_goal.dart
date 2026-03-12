import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:super_tooltip/super_tooltip.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/goal_saving_model.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/goal_detail_bloc.dart';

Widget savingItem({
  required BuildContext context,
  required String formatCurr,
  required GoalSavingModel data,
}) {
  final controller = SuperTooltipController();
  final key = GlobalKey();
  return SuperTooltip(
    key: key,
    controller: controller,
    barrierConfig: const BarrierConfiguration(color: Colors.transparent),
    content: GestureDetector(
      onTap: () async {
        controller
          ..hideTooltip()
          ..dispose();
        final result = await dialogDelete(context);
        if (result) {
          // ignore: use_build_context_synchronously
          context.read<GoalDetailBloc>().add(DeleteSaving(data));
        }
      },
      child: Text(
        AppLocalizations.of(context)!.delete,
        style: const TextStyle(
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: ShapeDecoration(
        color: const Color(0x3D787880),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.yMd(formatCurr).format(data.date),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9.5,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w500,
            ),
          ),
          NominalMoneyFormatter(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 9.5,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
            amount: data.amount,
            isWithName: true,
          ),
        ],
      ),
    ),
  );
}
