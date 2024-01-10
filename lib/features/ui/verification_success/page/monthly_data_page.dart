// ignore_for_file: must_be_immutable

import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/common_widget.dart';
import '../../../../injection.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../../../repository/auth_repository.dart';
import '../../../repository/settings_repository.dart';
import '../../language_currency/lang_currency_bloc.dart';
import '../../language_currency/lang_export.dart';
import '../bloc/monthly_data_bloc.dart';
import '../widget/rec_day_picker_widget.dart';
import '../widget/text_field_monthly_data.dart';
import '../widget/text_monthly_data.dart';

class MonthlyDataPage extends StatelessWidget {
  const MonthlyDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return MonthlyDataBloc(
          settingsRepo: getIt<SettingsRepository>(),
          authRepo: getIt<AuthRepository>(),
        );
      },
      child: const MonthlyDataPageContent(),
    );
  }
}

class MonthlyDataPageContent extends StatelessWidget {
  const MonthlyDataPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 100.w, height: 58.hmea),
            BlocBuilder<MonthlyDataBloc, MonthlyDataState>(
              builder: (context, state) {
                return Text(
                  (state.state == VerifOnboardPos.income)
                      ? AppLocalizations.of(context)!.monthlyIncome
                      : AppLocalizations.of(context)!.monthlyBudget,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.5.sp,
                    fontFamily: FontFamily.bungee,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            ),
            SizedBox(height: 100.hmea),
            BlocBuilder<MonthlyDataBloc, MonthlyDataState>(
              builder: (context, state) {
                switch (state.state) {
                  case VerifOnboardPos.income:
                    return TextMonthlyData(
                      text: AppLocalizations.of(context)!.monBudgetIncomeQuest,
                    );
                  case VerifOnboardPos.budget:
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextMonthlyData(
                        text: AppLocalizations.of(context)!.monBudgetSpentQuest,
                      ),
                    );
                }
              },
            ),
            SizedBox(height: 92.hmea),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                  builder: (context, state) {
                    return Text(
                      state.selectedCurrency.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
                SizedBox(width: 6.wmea),
                const TextFieldMonthlyData(),
              ],
            ),
            BlocBuilder<MonthlyDataBloc, MonthlyDataState>(
              buildWhen: (p, c) {
                return p.state != c.state;
              },
              builder: (context, state) {
                if (state.state == VerifOnboardPos.income) {
                  return recDayPickerWidget(context);
                }

                return SizedBox(height: 200.hmea);
              },
            ),
            BlocBuilder<MonthlyDataBloc, MonthlyDataState>(
              builder: (context, state) {
                return AnimatedSmoothIndicator(
                  activeIndex: (state.state == VerifOnboardPos.income) ? 0 : 1,
                  count: 2,
                  effect: ExpandingDotsEffect(
                    spacing: 8.wmea,
                    dotColor: Colors.white,
                    activeDotColor: const Color(0xFFF06AC9),
                  ),
                  curve: Curves.easeInOut,
                );
              },
            ),
            SizedBox(height: 48.hmea),
            BlocBuilder<MonthlyDataBloc, MonthlyDataState>(
              builder: (context, state) {
                return PinkButton(
                  onTap: () {
                    switch (state.state) {
                      case VerifOnboardPos.income:
                        context.read<MonthlyDataBloc>().add(SetIncome());
                        break;
                      case VerifOnboardPos.budget:
                        context.read<MonthlyDataBloc>().add(SetBudget());
                        break;
                    }
                  },
                  name: AppLocalizations.of(context)!.next,
                );
              },
            ),
            BlocBuilder<MonthlyDataBloc, MonthlyDataState>(
              builder: (context, state) {
                if (state.state == VerifOnboardPos.income) {
                  return const SizedBox();
                }

                return Padding(
                  padding: EdgeInsets.only(top: 8.hmea),
                  child: BlackButton(
                    name: AppLocalizations.of(context)!.back,
                    onTap: () {
                      context.read<MonthlyDataBloc>().add(
                            SetState(
                              VerifOnboardPos.income,
                            ),
                          );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
