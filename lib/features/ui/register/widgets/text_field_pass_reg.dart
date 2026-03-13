import '../../../../resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../resources/gen/fonts.gen.dart';

import '../../language_currency/lang_export.dart';
import '../bloc/register_bloc.dart';

class TextFieldPassReg extends StatefulWidget {
  const TextFieldPassReg({super.key});

  @override
  State<TextFieldPassReg> createState() => _TextFieldPassRegState();
}

class _TextFieldPassRegState extends State<TextFieldPassReg> {
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
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (p, c) {
                return p.isEnableObscurePass != c.isEnableObscurePass;
              },
              builder: (context, state) {
                return TextFormField(
                  focusNode: _focus,
                  obscureText: state.isEnableObscurePass,
                  onChanged: (value) {
                    context.read<RegisterBloc>().add(ChangePassword(value));
                  },
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: AppLocalizations.of(context)!.password,
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14.5,
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
              context.read<RegisterBloc>().add(ToggleEyePass());
            },
            child: BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (p, c) {
                return p.isEnableObscurePass != c.isEnableObscurePass;
              },
              builder: (context, state) {
                if (state.isEnableObscurePass) {
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
