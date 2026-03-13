import '../../bloc/goal_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../resources/gen/fonts.gen.dart';
import '../../../../language_currency/lang_export.dart';

class TextFieldNameEditGoal extends StatefulWidget {
  const TextFieldNameEditGoal({super.key});
  static late TextEditingController textEditingController;
  @override
  State<TextFieldNameEditGoal> createState() => _TextFieldNameEditGoalState();
}

class _TextFieldNameEditGoalState extends State<TextFieldNameEditGoal> {
  @override
  void initState() {
    TextFieldNameEditGoal.textEditingController = TextEditingController();
    context.read<GoalDetailBloc>().add(InitTempEdit());
    super.initState();
  }

  @override
  void dispose() {
    TextFieldNameEditGoal.textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextFieldNameEditGoal.textEditingController,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14.5,
        fontFamily: FontFamily.cabinetGrotesk,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration.collapsed(
        hintText: AppLocalizations.of(context)!.name,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14.5,
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
