import 'package:cling/resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../bloc/login_bloc.dart';

class TextFieldPassLogin extends StatelessWidget {
  const TextFieldPassLogin({super.key});

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
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return TextFormField(
                    obscureText: state.isObscure,
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
                context.read<LoginBloc>().add(ToggleEye());
              },
              child: BlocBuilder<LoginBloc, LoginState>(
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
      ),
    );
  }
}
