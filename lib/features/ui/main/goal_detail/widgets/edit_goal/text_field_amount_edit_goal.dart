import 'package:cling/features/ui/language_currency/lang_currency_bloc.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/gen/fonts.gen.dart';
import '../../bloc/goal_detail_bloc.dart';

class TextFieldAmountEditGoal extends StatefulWidget {
  const TextFieldAmountEditGoal({super.key});
  static late TextEditingController textEditingController;

  @override
  State<TextFieldAmountEditGoal> createState() =>
      _TextFieldAmountEditGoalState();
}

class _TextFieldAmountEditGoalState extends State<TextFieldAmountEditGoal> {
  @override
  void initState() {
    TextFieldAmountEditGoal.textEditingController = TextEditingController();
    context.read<GoalDetailBloc>().add(InitAmountEdit());
    super.initState();
  }

  @override
  void dispose() {
    TextFieldAmountEditGoal.textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextFieldAmountEditGoal.textEditingController,
      inputFormatters: [
        CurrencyTextInputFormatter(
          locale: context
              .watch<LangCurrencyBloc>()
              .state
              .selectedCurrency
              .value
              .toLanguageTag(),
          symbol: "",
          decimalDigits: 2,
        ),
      ],
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      cursorColor: Colors.black,
      style: TextStyle(
        color: Colors.black,
        fontSize: 10.5.sp,
        fontFamily: FontFamily.cabinetGrotesk,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration.collapsed(
        hintText: '0',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 10.5.sp,
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
