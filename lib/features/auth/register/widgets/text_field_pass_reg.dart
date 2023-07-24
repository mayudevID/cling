import 'package:cling/resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../bloc/register_bloc.dart';

class TextFieldPassReg extends StatelessWidget {
  const TextFieldPassReg({super.key});

  @override
  Widget build(BuildContext context) {
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
                  obscureText: state.isEnableObscurePass,
                  onChanged: (value) {},
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Password',
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
              context.read<RegisterBloc>().add(ToggleEyePass());
            },
            child: BlocBuilder<RegisterBloc, RegisterState>(
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
