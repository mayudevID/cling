import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/register_bloc.dart';

Widget textFieldConPassReg(BuildContext context) {
  return Container(
    decoration: ShapeDecoration(
      color: const Color(0xFF313131),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    padding: EdgeInsets.symmetric(
      vertical: 16.hmea,
      horizontal: 16.wmea,
    ),
    child: Row(
      children: [
        Expanded(
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              return TextFormField(
                obscureText: state.isEnableObscureConfirmPass,
                onChanged: (value) {
                  context.read<RegisterBloc>().add(ChangeConfPassword(value));
                },
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration.collapsed(
                  hintText: AppLocalizations.of(context)!.confirmPassword,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.5.sp,
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
