import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/home_bloc.dart';
import 'tag_currency.dart';
import 'warning_amount_icon.dart';

Widget incomeAndExpense(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: 24.w,
    ),
    width: double.infinity,
    padding: EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 16.h,
    ),
    decoration: BoxDecoration(
      color: const Color(0x3D787880),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.currentBalance,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            BlocBuilder<HomeBloc, HomeState>(buildWhen: (p, c) {
              return p.amountIncomeThisMonth != c.amountIncomeThisMonth ||
                  p.amountExpenseThisMonth != c.amountExpenseThisMonth;
            }, builder: (context, state) {
              final currBalance =
                  state.amountIncomeThisMonth - state.amountExpenseThisMonth;
              if (currBalance >= 0) return const SizedBox();

              return warningAmountIcon(
                content: AppLocalizations.of(context)!.warningMonthlyBudget,
              );
            }),
            SizedBox(width: 8.w),
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (p, c) {
                return p.amountIncomeThisMonth != c.amountIncomeThisMonth ||
                    p.amountExpenseThisMonth != c.amountExpenseThisMonth;
              },
              builder: (context, state) {
                final currBalance =
                    state.amountIncomeThisMonth - state.amountExpenseThisMonth;
                return NominalMoneyFormatter(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                  amount: currBalance,
                  isWithName: true,
                );
              },
            ),
          ],
        ),
        SizedBox(
          height: 16.h,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF07AC65),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 10.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.income} ✨',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.5.sp,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      tagCurrency(context),
                      BlocBuilder<HomeBloc, HomeState>(
                        buildWhen: (prev, curr) {
                          return prev.amountIncomeThisMonth !=
                              curr.amountIncomeThisMonth;
                        },
                        builder: (context, state) {
                          return NominalMoneyFormatter(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 9.5.sp,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w500,
                            ),
                            amount: state.amountIncomeThisMonth,
                            isWithName: false,
                            textAlign: TextAlign.right,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 16.w,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE54C19),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 10.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.expense} 🙏',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.5.sp,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      tagCurrency(context),
                      BlocBuilder<HomeBloc, HomeState>(
                        buildWhen: (prev, curr) {
                          return prev.amountExpenseThisMonth !=
                              curr.amountExpenseThisMonth;
                        },
                        builder: (context, state) {
                          return NominalMoneyFormatter(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 9.5.sp,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w500,
                            ),
                            amount: state.amountExpenseThisMonth,
                            isWithName: false,
                            textAlign: TextAlign.right,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
