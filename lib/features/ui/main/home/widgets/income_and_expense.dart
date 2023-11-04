import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/main/home/bloc/home_bloc.dart';
import 'package:cling/features/ui/main/home/widgets/tag_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';

Widget incomeAndExpense(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: 24.wmea,
    ),
    width: double.infinity,
    padding: EdgeInsets.symmetric(
      horizontal: 16.wmea,
      vertical: 16.hmea,
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
                fontSize: 12.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
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
                    fontSize: 12.5.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                  amount: currBalance,
                  decimalDigits: 2,
                  isWithName: true,
                );
              },
            ),
          ],
        ),
        SizedBox(
          height: 16.hmea,
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
                    horizontal: 8.wmea,
                    vertical: 10.hmea,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.income} ✨',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5.sp,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 6.hmea,
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
                              fontSize: 10.5.sp,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w500,
                            ),
                            amount: state.amountIncomeThisMonth,
                            decimalDigits: 2,
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
              width: 16.wmea,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE54C19),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.wmea,
                    vertical: 10.hmea,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.expense} 🙏',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5.sp,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 6.hmea,
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
                              fontSize: 10.5.sp,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w500,
                            ),
                            amount: state.amountExpenseThisMonth,
                            decimalDigits: 2,
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
