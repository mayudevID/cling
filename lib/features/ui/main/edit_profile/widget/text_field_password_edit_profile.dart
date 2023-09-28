import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/edit_profile_bloc.dart';

class TextFieldPasswordEditProfile extends StatefulWidget {
  const TextFieldPasswordEditProfile({super.key});
  static late TextEditingController textEditingController;

  @override
  State<TextFieldPasswordEditProfile> createState() =>
      _TextFieldPasswordRegState();
}

class _TextFieldPasswordRegState extends State<TextFieldPasswordEditProfile> {
  final _focus = FocusNode();

  @override
  void initState() {
    TextFieldPasswordEditProfile.textEditingController =
        TextEditingController();
    TextFieldPasswordEditProfile.textEditingController.addListener(() {
      print("berubah");
    });
    _focus.addListener(_onFocusChange);
    context.read<EditProfileBloc>().add(const InitialValueEdit("password"));
    super.initState();
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    TextFieldPasswordEditProfile.textEditingController.dispose();
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
            child: BlocBuilder<EditProfileBloc, EditProfileState>(
              buildWhen: (p, c) {
                return p.isObscure != c.isObscure;
              },
              builder: (context, state) {
                return TextFormField(
                  focusNode: _focus,
                  obscureText: state.isObscure,
                  controller:
                      TextFieldPasswordEditProfile.textEditingController,
                  onChanged: (value) {
                    //context.read<RegisterBloc>().add(ChangeName(value));
                  },
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: AppLocalizations.of(context)!.password,
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
              context.read<EditProfileBloc>().add(ToggleEyeEditProfile());
            },
            child: BlocBuilder<EditProfileBloc, EditProfileState>(
              buildWhen: (p, c) {
                return p.isObscure != c.isObscure;
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
