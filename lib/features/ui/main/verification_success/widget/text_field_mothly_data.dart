// ignore_for_file: must_be_immutable

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';

class TextFieldMonthlyData extends StatefulWidget {
  const TextFieldMonthlyData({super.key});
  static late TextEditingController textEditingController;

  @override
  State<TextFieldMonthlyData> createState() => _TextFieldMonthlyDataState();
}

class _TextFieldMonthlyDataState extends State<TextFieldMonthlyData> {
  @override
  void initState() {
    TextFieldMonthlyData.textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoSizeTextField(
      controller: TextFieldMonthlyData.textEditingController,
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
      fullwidth: false,
      maxLines: 1,
      style: TextStyle(
        color: Colors.white,
        fontSize: 22.sp,
        fontFamily: FontFamily.cabinetGrotesk,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration.collapsed(
        hintText: "0",
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 22.sp,
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  void dispose() {
    TextFieldMonthlyData.textEditingController.dispose();
    super.dispose();
  }
}
