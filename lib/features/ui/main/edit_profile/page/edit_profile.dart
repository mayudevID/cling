import 'package:cling/core/utils.dart';
import 'package:cling/features/repository/auth_repository.dart';
import 'package:cling/features/repository/settings_repository.dart';
import 'package:cling/features/ui/main/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:cling/injection.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/common_widget.dart';
import '../../../language_currency/lang_export.dart';
import '../widget/text_field_email_edit_profile.dart';
import '../widget/text_field_name_edit_profile.dart';
import '../widget/text_field_password_edit_profile.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileBloc(
        context: context,
        settingsRepo: getIt<SettingsRepository>(),
        authRepo: getIt<AuthRepository>(),
      ),
      child: const EditProfilePageContent(),
    );
  }
}

class EditProfilePageContent extends StatelessWidget {
  const EditProfilePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF101010),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.wmea),
          child: Column(
            children: [
              appBarProfile(
                context: context,
                title: "Edit Profile",
                textButton: "Save",
                onTapButton: () async {
                  context.read<EditProfileBloc>().add(SaveNewProfile());
                },
              ),
              SizedBox(
                height: 32.hmea,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(
                height: 8.hmea,
              ),
              const TextFieldNameEditProfile(),
              SizedBox(
                height: 24.hmea,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(
                height: 8.hmea,
              ),
              const TextFieldEmailEditProfile(),
              SizedBox(
                height: 24.hmea,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.password,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(
                height: 8.hmea,
              ),
              const TextFieldPasswordEditProfile(),
            ],
          ),
        ),
      ),
    );
  }
}
