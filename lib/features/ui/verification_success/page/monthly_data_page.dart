// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          children: [
            const SizedBox(width: 100, height: 58),
            BlocBuilder<MonthlyDataBloc, MonthlyDataState>(
              builder: (context, state) {
                return Text(
                  (state.state == VerifOnboardPos.income)
                      ? AppLocalizations.of(context)!.monthlyIncome
                      : AppLocalizations.of(context)!.monthlyBudget,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontFamily: FontFamily.bungee,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            ),
            const SizedBox(height: 100),
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
            const SizedBox(height: 92),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                  builder: (context, state) {
                    return Text(
                      state.selectedCurrency.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 6),
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

                return const SizedBox(height: 200);
              },
            ),
            BlocBuilder<MonthlyDataBloc, MonthlyDataState>(
              builder: (context, state) {
                return AnimatedSmoothIndicator(
                  activeIndex: (state.state == VerifOnboardPos.income) ? 0 : 1,
                  count: 2,
                  effect: const ExpandingDotsEffect(
                    dotColor: Colors.white,
                    activeDotColor: Color(0xFFF06AC9),
                  ),
                );
              },
            ),
            const SizedBox(height: 48),
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
                  padding: const EdgeInsets.only(top: 8),
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
