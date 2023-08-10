import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cling/core/utils.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../resources/gen/fonts.gen.dart';

class MonthlyBudgetSpendPage extends StatelessWidget {
  const MonthlyBudgetSpendPage({super.key});

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "How much do you want to spend monthly?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
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
                  onChanged: (val) {},
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
              onTap: () {},
              name: "Next",
            ),
          ],
        ),
      ),
    );
  }
}
