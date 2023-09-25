import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/edit_profile_bloc.dart';

class TextFieldEmailEditProfile extends StatefulWidget {
  const TextFieldEmailEditProfile({super.key});
  static late TextEditingController textEditingController;

  @override
  State<TextFieldEmailEditProfile> createState() => _TextFieldEmailRegState();
}

class _TextFieldEmailRegState extends State<TextFieldEmailEditProfile> {
  final _focus = FocusNode();

  @override
  void initState() {
    TextFieldEmailEditProfile.textEditingController = TextEditingController();
    _focus.addListener(_onFocusChange);
    context.read<EditProfileBloc>().add(const InitialValueEdit("email"));
    super.initState();
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    TextFieldEmailEditProfile.textEditingController.dispose();
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
      child: TextFormField(
        focusNode: _focus,
        controller: TextFieldEmailEditProfile.textEditingController,
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
          hintText: AppLocalizations.of(context)!.email,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
