// ignore_for_file: must_be_immutable

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cling/core/common_widget.dart';

import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class MonthlyBudgetIncomePage extends StatelessWidget {
  const MonthlyBudgetIncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            Text(
              'First thing first!\nwhat\'s your monthly income?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w500,
              ),
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
                AutoSizeTextField(
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      locale: "id",
                      symbol: "",
                      decimalDigits: 0,
                    ),
                  ],
                  cursorColor: Colors.white,
                  enableInteractiveSelection: false,
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(),
                  fullwidth: false,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                  onChanged: (val) {
                    //monthlyBudgetIncome = val;
                  },
                  decoration: InputDecoration.collapsed(
                    hintText: "0",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 22.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 187.hmea,
            ),
            PinkButton(
              onTap: () {
                //final val = monthlyBudgetIncome.replaceAll(".", "").trim();
                // if (val == "0" || val.isEmpty) {
                //   errorSnackbar(context, "Monthly income must above 0");
                // } else {
                //   Navigator.pushNamed(context, RouteName.monthlyBudgetSpend);
                // }
              },
              name: "Next",
            ),
          ],
        ),
      ),
    );
  }
}
