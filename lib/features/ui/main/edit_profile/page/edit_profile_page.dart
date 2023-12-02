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
                onTapButton: () {},
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
                    fontSize: 10.sp,
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
              BlocBuilder<EditProfileBloc, EditProfileState>(
                buildWhen: (p, c) {
                  return p.isNameSame != c.isNameSame;
                },
                builder: (context, state) {
                  if (!state.isNameSame) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 24.hmea),
                      child: PinkButton(
                        onTap: () {
                          context.read<EditProfileBloc>().add(SaveNewName());
                        },
                        name: AppLocalizations.of(context)!.save,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
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
              BlocBuilder<EditProfileBloc, EditProfileState>(
                buildWhen: (p, c) {
                  return p.isEmailSame != c.isEmailSame;
                },
                builder: (context, state) {
                  if (!state.isEmailSame) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 24.hmea),
                      child: PinkButton(
                        onTap: () {
                          context.read<EditProfileBloc>().add(SaveNewEmail());
                        },
                        name: AppLocalizations.of(context)!.save,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.password,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(
                height: 8.hmea,
              ),
              PinkButton(
                onTap: () async {
                  context.read<EditProfileBloc>().add(ChangePassword());
                },
                name: "Change Password",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
