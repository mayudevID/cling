import '../../../../../../core/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'dart:math' as math;

import '../../../../../../core/route.dart';
import '../../../../../../resources/gen/assets.gen.dart';
import '../../../../../../resources/gen/fonts.gen.dart';
import '../../../../language_currency/lang_currency_bloc.dart';
import '../../../../language_currency/lang_export.dart';
import '../../bloc/goal_detail_bloc.dart';
import '../../pages/goal_detail_page.dart';
import 'logo_goal_widget_on_edit_goal.dart';
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
    builder: (bottomSheetContext) {
      return BlocProvider.value(
        value: BlocProvider.of<GoalDetailBloc>(
          GoalDetailPage.navKeyMain.currentContext!,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
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
                    const Text(
                      "Edit Goal",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
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
                const SizedBox(height: 8),
                logoGoalWidgetOnEditGoal(context),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: ShapeDecoration(
                    color: const Color.fromARGB(255, 224, 224, 224),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: const TextFieldNameEditGoal(),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                    buildWhen: (p, c) {
                      return p.selectedCurrency.name != c.selectedCurrency.name;
                    },
                    builder: (context, state) {
                      return Text(
                        '${AppLocalizations.of(context)!.amount} Target (${state.selectedCurrency.name})',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w800,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final ctxt = GoalDetailPage.navKeyMain.currentContext!;
                    final amountRes = await Navigator.pushNamed(
                      bottomSheetContext,
                      RouteName.calc,
                      arguments: ctxt.read<GoalDetailBloc>().state.tempAmount,
                    );

                    if ((amountRes! as List)[0] == true) {
                      // ignore: use_build_context_synchronously
                      ctxt
                          .read<GoalDetailBloc>()
                          .add(SetTempAmountInput((amountRes as List)[1]));
                    }
                  },
                  child: Container(
                    decoration: ShapeDecoration(
                      color: const Color.fromARGB(255, 224, 224, 224),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
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
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: FontFamily.cabinetGrotesk,
                                fontWeight: FontWeight.w800,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: BlocBuilder<GoalDetailBloc, GoalDetailState>(
                            buildWhen: (p, c) {
                              return p.tempAmount != c.tempAmount;
                            },
                            builder: (context, state) {
                              return NominalMoneyFormatter(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: FontFamily.cabinetGrotesk,
                                  fontWeight: FontWeight.w500,
                                ),
                                amount: state.tempAmount,
                                isWithName: false,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                PinkButton(
                  onTap: () {
                    GoalDetailPage.navKeyMain.currentContext!
                        .read<GoalDetailBloc>()
                        .add(SaveEdit());
                    Navigator.pop(context);
                  },
                  name: "Edit",
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    },
  );
}
