import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../language_currency/lang_export.dart';
import '../bloc/login_bloc.dart';

class TextFieldEmailLogin extends StatefulWidget {
  const TextFieldEmailLogin({super.key});

  @override
  State<TextFieldEmailLogin> createState() => _TextFieldEmailLoginState();
}

class _TextFieldEmailLoginState extends State<TextFieldEmailLogin> {
  final _focus = FocusNode();

  @override
  void initState() {
    _focus.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
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
        onChanged: (value) {
          context.read<LoginBloc>().add(ChangeEmail(value));
        },
        cursorColor: Colors.white,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14.5,
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration.collapsed(
          hintText: AppLocalizations.of(context)!.email,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14.5,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
