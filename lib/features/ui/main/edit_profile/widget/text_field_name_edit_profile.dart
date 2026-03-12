// ignore_for_file: must_be_immutable

import '../bloc/edit_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';

class TextFieldNameEditProfile extends StatefulWidget {
  const TextFieldNameEditProfile({super.key});
  static late TextEditingController textEditingController;

  @override
  State<TextFieldNameEditProfile> createState() => _TextFieldNameRegState();
}

class _TextFieldNameRegState extends State<TextFieldNameEditProfile> {
  final _focus = FocusNode();

  @override
  void initState() {
    TextFieldNameEditProfile.textEditingController = TextEditingController();
    TextFieldNameEditProfile.textEditingController.addListener(() {
      context.read<EditProfileBloc>().add(CheckName());
    });
    _focus.addListener(_onFocusChange);
    context.read<EditProfileBloc>().add(const InitialValueEdit("name"));
    super.initState();
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    TextFieldNameEditProfile.textEditingController.dispose();
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF313131),
        borderRadius: BorderRadius.circular(10),
        border: _focus.hasFocus
            ? Border.all(
                color: Colors.white,
              )
            : null,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      child: TextFormField(
        focusNode: _focus,
        controller: TextFieldNameEditProfile.textEditingController,
        onChanged: (value) {
          //context.read<RegisterBloc>().add(ChangeName(value));
        },
        cursorColor: Colors.white,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10.5,
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration.collapsed(
          hintText: AppLocalizations.of(context)!.name,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 10.5,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
