import 'package:auto_size_text_field/auto_size_text_field.dart';
import '../../language_currency/lang_currency_bloc.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../resources/gen/fonts.gen.dart';

class TextFieldMonthlyData extends StatelessWidget {
  const TextFieldMonthlyData({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AutoSizeTextField(
      controller: controller,
      inputFormatters: [
        CurrencyTextInputFormatter.currency(
          locale: context.select(
            (LangCurrencyBloc bloc) =>
                bloc.state.selectedCurrency.value.toLanguageTag(),
          ),
          symbol: "",
          decimalDigits: 0,
        ),
      ],
      cursorColor: Colors.white,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      fullwidth: false,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: FontFamily.cabinetGrotesk,
        fontWeight: FontWeight.w700,
      ),
      decoration: const InputDecoration.collapsed(
        hintText: "0",
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 20,
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
