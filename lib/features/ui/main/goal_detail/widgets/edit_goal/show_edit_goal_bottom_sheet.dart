import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

import '../../../../../../resources/gen/assets.gen.dart';
import '../../../../../../resources/gen/fonts.gen.dart';
import '../../../../language_currency/lang_currency_bloc.dart';
import '../../../../language_currency/lang_export.dart';
import '../../bloc/goal_detail_bloc.dart';
import '../../pages/goal_detail_page.dart';
import 'logo_goal_widget_on_edit_goal.dart';
import 'text_field_amount_edit_goal.dart';
import 'text_field_name_edit_goal.dart';

void showEditGoalBottomSheet(BuildContext context) {
  showMaterialModalBottomSheet(
    context: context,
    duration: const Duration(milliseconds: 150),
    isDismissible: false,
    enableDrag: false,
    shape: const BeveledRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    builder: (context) {
      return BlocProvider.value(
        value: BlocProvider.of<GoalDetailBloc>(
          GoalDetailPage.navKeyMain.currentContext!,
        ),
        child: Container(
          padding: EdgeInsets.all(24.wmea),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Edit Goal",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Transform.rotate(
                        angle: math.pi / 4,
                        child: Assets.lib.resources.images.plus.svg(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.hmea),
                logoGoalWidgetOnEditGoal(context),
                SizedBox(height: 8.hmea),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: 8.hmea),
                Container(
                  decoration: ShapeDecoration(
                    color: const Color.fromARGB(255, 224, 224, 224),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.hmea,
                    horizontal: 16.wmea,
                  ),
                  child: const TextFieldNameEditGoal(),
                ),
                SizedBox(height: 16.hmea),
                Align(
                  alignment: Alignment.centerLeft,
                  child: BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                    buildWhen: (p, c) {
                      return p.selectedCurrency.name != c.selectedCurrency.name;
                    },
                    builder: (context, state) {
                      return Text(
                        '${AppLocalizations.of(context)!.amount} Target (${state.selectedCurrency.name})',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10.sp,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w800,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 8.hmea,
                ),
                Container(
                  decoration: ShapeDecoration(
                    color: const Color.fromARGB(255, 224, 224, 224),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.hmea,
                    horizontal: 16.wmea,
                  ),
                  child: Row(
                    children: [
                      BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                        buildWhen: (p, c) {
                          return p.selectedCurrency.name !=
                              c.selectedCurrency.name;
                        },
                        builder: (context, state) {
                          return Text(
                            state.selectedCurrency.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10.sp,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w800,
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 10.wmea,
                      ),
                      Expanded(
                        child: BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                          buildWhen: (p, c) {
                            return p.selectedCurrency.name !=
                                c.selectedCurrency.name;
                          },
                          builder: (context, state) {
                            return const TextFieldAmountEditGoal();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.hmea),
                PinkButton(
                  onTap: () {
                    GoalDetailPage.navKeyMain.currentContext!
                        .read<GoalDetailBloc>()
                        .add(SaveEdit());
                    Navigator.pop(context);
                  },
                  name: "Edit",
                ),
                SizedBox(height: 24.hmea),
              ],
            ),
          ),
        ),
      );
    },
  );
}
