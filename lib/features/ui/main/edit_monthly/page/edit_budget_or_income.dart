import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../repository/auth_repository.dart';
import '../../../../repository/settings_repository.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/edit_monthly_bloc.dart';
import '../widget/text_field_edit_monthly.dart';

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
      ),
      child: EditMonBudgetOrIncomePageContent(monthlyMode: monthlyMode),
    );
  }
}

class EditMonBudgetOrIncomePageContent extends StatelessWidget {
  const EditMonBudgetOrIncomePageContent(
      {super.key, required this.monthlyMode});
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
                textButton: "Save",
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
              Container(
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
                    const TextFieldEditMonthly(),
                  ],
                ),
              ),
              if (monthlyMode == EditMonthlyMode.income) ...[
                SizedBox(height: 32.hmea),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.recurringEveryDate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    BlocBuilder<EditMonthlyBloc, EditMonthlyState>(
                      buildWhen: (p, c) {
                        return p.changeDateRec != c.changeDateRec;
                      },
                      builder: (context, state) {
                        return Text(
                          getRankString(state.changeDateRec),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 8.wmea),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFF599DA),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.change,
                        style: TextStyle(
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w600,
                          fontSize: 9.5.sp,
                        ),
                      ),
                    )
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
