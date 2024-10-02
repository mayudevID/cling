import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../language_currency/lang_export.dart';
import '../bloc/register_bloc.dart';

class TextFieldConPassReg extends StatefulWidget {
  const TextFieldConPassReg({super.key});

  @override
  State<TextFieldConPassReg> createState() => _TextFieldConPassRegState();
}

class _TextFieldConPassRegState extends State<TextFieldConPassReg> {
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
        vertical: 16.h,
        horizontal: 16.w,
      ),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (p, c) {
                return p.isEnableObscureConfirmPass !=
                    c.isEnableObscureConfirmPass;
              },
              builder: (context, state) {
                return TextFormField(
                  focusNode: _focus,
                  obscureText: state.isEnableObscureConfirmPass,
                  onChanged: (value) {
                    context.read<RegisterBloc>().add(ChangeConfPassword(value));
                  },
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: AppLocalizations.of(context)!.confirmPassword,
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
              context.read<RegisterBloc>().add(ToggleEyeConfirmPass());
            },
            child: BlocBuilder<RegisterBloc, RegisterState>(
              buildWhen: (p, c) {
                return p.isEnableObscureConfirmPass !=
                    c.isEnableObscureConfirmPass;
              },
              builder: (context, state) {
                if (state.isEnableObscureConfirmPass) {
                  return Assets.lib.resources.images.eyeOff.svg();
                }

                return Assets.lib.resources.images.eyeOn.svg();
              },
            ),
          )
        ],
      ),
    );
  }
}
