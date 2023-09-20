import 'package:cling/features/ui/main/edit_monthly/bloc/edit_monthly_bloc.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_currency_bloc.dart';

class TextFieldEditMonthly extends StatefulWidget {
  const TextFieldEditMonthly({super.key});
  static late TextEditingController textEditingController;

  @override
  State<TextFieldEditMonthly> createState() => _TextFieldEditMonthlyState();
}

class _TextFieldEditMonthlyState extends State<TextFieldEditMonthly> {
  @override
  void initState() {
    TextFieldEditMonthly.textEditingController = TextEditingController();
    context.read<EditMonthlyBloc>().add(InitialValue());
    super.initState();
  }

  @override
  void dispose() {
    TextFieldEditMonthly.textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: TextFieldEditMonthly.textEditingController,
        inputFormatters: [
          CurrencyTextInputFormatter(
            locale: context.select(
              (LangCurrencyBloc bloc) =>
                  bloc.state.selectedCurrency.value.toLanguageTag(),
            ),
            symbol: "",
            decimalDigits: 2,
          ),
        ],
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.5.sp,
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration.collapsed(
          hintText: '0',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
