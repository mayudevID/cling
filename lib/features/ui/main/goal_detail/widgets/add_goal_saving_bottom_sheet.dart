import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'dart:math' as math;
import '../../../../../core/common_widget.dart';
import '../../../../../core/route.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/goal_detail_bloc.dart';

void addGoalSavingBottomSheet(BuildContext mainContext) {
  showMaterialModalBottomSheet(
    duration: const Duration(milliseconds: 200),
    context: mainContext,
    shape: const BeveledRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    builder: (context) {
      return BlocProvider.value(
        value: BlocProvider.of<GoalDetailBloc>(mainContext),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child: Assets.lib.resources.images.plus.svg(),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Saving Date',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
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
                  child: Row(
                    children: [
                      BlocBuilder<GoalDetailBloc, GoalDetailState>(
                        buildWhen: (prev, curr) {
                          return prev.selectedDate != curr.selectedDate;
                        },
                        builder: (context, state) {
                          final date = DateFormat.yMd(
                            context.select(
                              (LangCurrencyBloc bloc) {
                                return bloc.state.selectedLanguage.value
                                    .toLanguageTag();
                              },
                            ),
                          ).format(state.selectedDate);

                          return Text(
                            date,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10.5,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          final now = DateTime.now();
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: now.subtract(const Duration(days: 186)),
                            lastDate: now,
                          );
                          if (pickedDate != null) {
                            // ignore: use_build_context_synchronously
                            mainContext
                                .read<GoalDetailBloc>()
                                .add(SetDateGoalInput(pickedDate));
                          }
                        },
                        child: Assets.lib.resources.images.calendar.svg(
                            // ignore: deprecated_member_use_from_same_package
                            color: Colors.black),
                      ),
                    ],
                  ),
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
                        '${AppLocalizations.of(context)!.amount} (${state.selectedCurrency.name})',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
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
                    final amountRes = await Navigator.pushNamed(
                      context,
                      RouteName.calc,
                      arguments:
                          mainContext.read<GoalDetailBloc>().state.amount,
                    );

                    if ((amountRes! as List)[0] == true) {
                      // ignore: use_build_context_synchronously
                      mainContext
                          .read<GoalDetailBloc>()
                          .add(SetAmountInput((amountRes as List)[1]));
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
                                fontSize: 10,
                                fontFamily: FontFamily.cabinetGrotesk,
                                fontWeight: FontWeight.w800,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: BlocBuilder<GoalDetailBloc, GoalDetailState>(
                            buildWhen: (p, c) => p.amount != c.amount,
                            builder: (context, state) {
                              return NominalMoneyFormatter(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: FontFamily.cabinetGrotesk,
                                  fontWeight: FontWeight.w500,
                                ),
                                amount: state.amount,
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
                    mainContext.read<GoalDetailBloc>().add(
                          AddSaving(),
                        );
                    Navigator.pop(context);
                  },
                  name: "Add Saving",
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
