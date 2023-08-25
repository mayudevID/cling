import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/main/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';

Widget incomeAndExpense(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: 20.wmea,
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
              'Current balance',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            NominalMoneyFormatter(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 12.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
              amount: 2000000,
              decimalDigits: 2,
              isWithName: true,
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
                      Text(
                        'IDR',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5.sp,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      BlocBuilder<HomeBloc, HomeState>(
                        buildWhen: (prev, curr) {
                          return prev.amountIncome != curr.amountIncome;
                        },
                        builder: (context, state) {
                          return Text(
                            NumberFormat.currency(
                              locale: "id",
                              decimalDigits: 2,
                              name: "",
                            ).format(state.amountIncome),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.5.sp,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w500,
                            ),
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
                          fontFamily: 'Cabinet Grotesk',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 6.hmea,
                      ),
                      Text(
                        'IDR',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5.sp,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      BlocBuilder<HomeBloc, HomeState>(
                        buildWhen: (prev, curr) {
                          return prev.amountExpense != curr.amountExpense;
                        },
                        builder: (context, state) {
                          return Text(
                            "-${NumberFormat.currency(
                              locale: "id",
                              decimalDigits: 2,
                              name: "",
                            ).format(state.amountExpense)}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.5.sp,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w500,
                            ),
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
