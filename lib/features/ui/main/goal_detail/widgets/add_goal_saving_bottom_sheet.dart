import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:cling/features/ui/main/goal_detail/bloc/goal_detail_bloc.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;
import '../../../../../core/common_widget.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../language_currency/lang_currency_bloc.dart';

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
          padding: EdgeInsets.symmetric(
            horizontal: 20.hmea,
            vertical: 20.hmea,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Saving Date',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w800,
                    ),
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
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10.5.sp,
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
                          DateTime? pickedDate = await showDatePicker(
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
                SizedBox(
                  height: 16.hmea,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                    buildWhen: (p, c) {
                      return p.selectedCurrency.name != c.selectedCurrency.name;
                    },
                    builder: (context, state) {
                      return Text(
                        '${AppLocalizations.of(context)!.amount} (${state.selectedCurrency.name})',
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
                            return TextFormField(
                              inputFormatters: [
                                CurrencyTextInputFormatter(
                                  locale: state.selectedCurrency.value
                                      .toLanguageTag(),
                                  symbol: "",
                                  decimalDigits: 2,
                                ),
                              ],
                              enableInteractiveSelection: false,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                context
                                    .read<GoalDetailBloc>()
                                    .add(SetAmountInput(value));
                              },
                              cursorColor: Colors.black,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.5.sp,
                                fontFamily: FontFamily.cabinetGrotesk,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText: '0',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10.5.sp,
                                  fontFamily: FontFamily.cabinetGrotesk,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.hmea,
                ),
                PinkButton(
                  onTap: () {
                    mainContext.read<GoalDetailBloc>().add(
                          AddSaving(),
                        );
                    Navigator.pop(context);
                  },
                  name: "Add Saving",
                ),
                SizedBox(
                  height: 24.hmea,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
