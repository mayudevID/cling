import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../language_currency/lang_export.dart';
import '../bloc/login_bloc.dart';

class TextFieldPassLogin extends StatefulWidget {
  const TextFieldPassLogin({super.key});

  @override
  State<TextFieldPassLogin> createState() => _TextFieldPassLoginState();
}

class _TextFieldPassLoginState extends State<TextFieldPassLogin> {
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
                width: 1,
                color: Colors.white,
              )
            : null,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 16.hmea,
        horizontal: 16.wmea,
      ),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (p, c) {
                return p.isObscure != c.isObscure;
              },
              builder: (context, state) {
                return TextFormField(
                  focusNode: _focus,
                  obscureText: state.isObscure,
                  onChanged: (value) {
                    context.read<LoginBloc>().add(ChangePassword(value));
                  },
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: AppLocalizations.of(context)!.password,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<LoginBloc>().add(ToggleEye());
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (previous, current) {
                return previous.isObscure != current.isObscure;
              },
              builder: (context, state) {
                if (state.isObscure) {
                  return Assets.lib.resources.images.eyeOff.svg();
                }

                return Assets.lib.resources.images.eyeOn.svg();
              },
            ),
          ),
        ],
      ),
    );
  }
}
