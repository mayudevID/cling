import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/assets.gen.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../bloc/register_bloc.dart';

class TextFieldConPassReg extends StatelessWidget {
  const TextFieldConPassReg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Utils.w(390).w,
      height: Utils.h(54).h,
      decoration: ShapeDecoration(
        color: const Color(0xFF313131),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return TextFormField(
                    obscureText: state.isEnableObscureConfirmPass,
                    onChanged: (value) {},
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Confirm Password',
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
      ),
    );
  }
}
