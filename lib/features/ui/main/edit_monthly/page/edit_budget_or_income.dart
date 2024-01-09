import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/route.dart';
import '../../../../../injection.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../repository/auth_repository.dart';
import '../../../../repository/settings_repository.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/edit_monthly_bloc.dart';
import 'dart:math' as math;

enum EditMonthlyMode { budget, income }

class EditMonBudgetOrIncomePage extends StatelessWidget {
  const EditMonBudgetOrIncomePage({super.key, required this.monthlyMode});
  final EditMonthlyMode monthlyMode;

  static GlobalKey<NavigatorState> navEditMon = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditMonthlyBloc(
        context: context,
        monthlyMode: monthlyMode,
        settingsRepo: getIt<SettingsRepository>(),
        authRepo: getIt<AuthRepository>(),
      )..add(InitialValue()),
      child: EditMonBudgetOrIncomePageContent(monthlyMode: monthlyMode),
    );
  }
}

class EditMonBudgetOrIncomePageContent extends StatelessWidget {
  const EditMonBudgetOrIncomePageContent({
    super.key,
    required this.monthlyMode,
  });
  final EditMonthlyMode monthlyMode;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: EditMonBudgetOrIncomePage.navEditMon,
        backgroundColor: const Color(0xFF101010),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.wmea),
          child: Column(
            children: [
              appBarProfile(
                context: context,
                title: (monthlyMode == EditMonthlyMode.budget)
                    ? AppLocalizations.of(context)!.monthlyBudget
                    : AppLocalizations.of(context)!.monthlyIncome,
                textButton: AppLocalizations.of(context)!.save,
                onTapButton: () {
                  context.read<EditMonthlyBloc>().add(SaveNewMonthly());
                },
              ),
              SizedBox(height: 32.hmea),
              Align(
                alignment: Alignment.centerLeft,
                child: BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                  builder: (context, state) {
                    return Text(
                      "Target (${state.selectedCurrency.name})",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w800,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 8.hmea),
              GestureDetector(
                onTap: () async {
                  final amountRes = await Navigator.pushNamed(
                    context,
                    RouteName.calc,
                    arguments: context.read<EditMonthlyBloc>().state.amount,
                  );

                  if ((amountRes! as List)[0] == true) {
                    // ignore: use_build_context_synchronously
                    context
                        .read<EditMonthlyBloc>()
                        .add(SetAmountInput((amountRes as List)[1]));
                  }
                },
                child: Container(
                  decoration: ShapeDecoration(
                    color: const Color(0xFF313131),
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
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w800,
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 10.wmea),
                      Expanded(
                        child: BlocBuilder<EditMonthlyBloc, EditMonthlyState>(
                          buildWhen: (p, c) {
                            return p.amount != c.amount;
                          },
                          builder: (context, state) {
                            return NominalMoneyFormatter(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
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
              if (monthlyMode == EditMonthlyMode.income) ...[
                SizedBox(height: 32.hmea),
                Text(
                  AppLocalizations.of(context)!.recurringEveryDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.hmea),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        int day = context
                                .read<EditMonthlyBloc>()
                                .state
                                .changeDateRec -
                            1;
                        context
                            .read<EditMonthlyBloc>()
                            .add(ChangeTempRecDay(day.clamp(0, 28)));
                      },
                      child: Assets
                          .lib.resources.images.fluentChevronLeft24Filled
                          .svg(),
                    ),
                    SizedBox(width: 16.wmea),
                    BlocBuilder<EditMonthlyBloc, EditMonthlyState>(
                      buildWhen: (p, c) {
                        return p.changeDateRec != c.changeDateRec;
                      },
                      builder: (context, state) {
                        return NumberPicker(
                          itemCount: 1,
                          axis: Axis.horizontal,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white),
                          ),
                          textMapper: (numberText) {
                            return getRankString(int.parse(numberText));
                          },
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontWeight: FontWeight.w600,
                          ),
                          selectedTextStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp),
                          value: state.changeDateRec,
                          minValue: 0,
                          maxValue: 28,
                          onChanged: (int value) {},
                        );
                      },
                    ),
                    SizedBox(width: 16.wmea),
                    GestureDetector(
                      onTap: () {
                        int day = context
                                .read<EditMonthlyBloc>()
                                .state
                                .changeDateRec +
                            1;
                        context
                            .read<EditMonthlyBloc>()
                            .add(ChangeTempRecDay(day.clamp(0, 28)));
                      },
                      child: Transform.rotate(
                        angle: math.pi,
                        child: Assets
                            .lib.resources.images.fluentChevronLeft24Filled
                            .svg(),
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
