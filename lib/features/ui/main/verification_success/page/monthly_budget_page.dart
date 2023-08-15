// ignore_for_file: must_be_immutable
import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/main/verification_success/bloc/monthly_budget_bloc.dart';
import 'package:cling/features/ui/main/verification_success/widget/text_field_mothly_budget.dart';
import 'package:cling/features/ui/main/verification_success/widget/text_monthly_budget.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nil/nil.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MonthlyBudgetPage extends StatelessWidget {
  const MonthlyBudgetPage({super.key});

  static final verifOnboardNavKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return MonthlyBudgetBloc();
      },
      child: const MonthlyBudgetPageContent(),
    );
  }
}

class MonthlyBudgetPageContent extends StatelessWidget {
  const MonthlyBudgetPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: MonthlyBudgetPage.verifOnboardNavKey,
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100.w,
              height: 58.hmea,
            ),
            Text(
              'monthly Budget',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: FontFamily.bungee,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 100.hmea,
            ),
            BlocBuilder<MonthlyBudgetBloc, MonthlyBudgetState>(
              builder: (context, state) {
                switch (state.state) {
                  case VerifOnboardPos.income:
                    return const TextMonthlyBudget(
                      text: 'First thing first!\nwhat\'s your monthly income?',
                    );
                  case VerifOnboardPos.spent:
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: TextMonthlyBudget(
                        text: "How much do you want to spend monthly?",
                      ),
                    );
                }
              },
            ),
            SizedBox(
              height: 92.hmea,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'IDR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: 6.wmea,
                ),
                const TextFieldMonthlyBudget(),
              ],
            ),
            SizedBox(
              height: 93.5.hmea,
            ),
            BlocBuilder<MonthlyBudgetBloc, MonthlyBudgetState>(
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
            SizedBox(
              height: 93.5.hmea,
            ),
            BlocBuilder<MonthlyBudgetBloc, MonthlyBudgetState>(
              builder: (context, state) {
                return PinkButton(
                  onTap: () {
                    switch (state.state) {
                      case VerifOnboardPos.income:
                        context.read<MonthlyBudgetBloc>().add(SetIncome());
                        break;
                      case VerifOnboardPos.spent:
                        context.read<MonthlyBudgetBloc>().add(SetSpent());
                        break;
                    }
                  },
                  name: "Next",
                );
              },
            ),
            BlocBuilder<MonthlyBudgetBloc, MonthlyBudgetState>(
              builder: (context, state) {
                if (state.state == VerifOnboardPos.income) {
                  return nil;
                }

                return Padding(
                  padding: EdgeInsets.only(top: 8.hmea),
                  child: BlackButton(
                    name: "Back",
                    onTap: () {
                      context.read<MonthlyBudgetBloc>().add(
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
