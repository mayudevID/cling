import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../injection.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../repository/auth_repository.dart';
import '../../../../repository/settings_repository.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/edit_profile_bloc.dart';
import '../widget/text_field_email_edit_profile.dart';
import '../widget/text_field_name_edit_profile.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileBloc(
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              appBarProfile(
                context: context,
                title: "Edit Profile",
                textButton: "Save",
                onTapButton: () {},
              ),
              const SizedBox(
                height: 32,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const TextFieldNameEditProfile(),
              const SizedBox(height: 24),
              BlocBuilder<EditProfileBloc, EditProfileState>(
                buildWhen: (p, c) {
                  return p.isNameSame != c.isNameSame;
                },
                builder: (context, state) {
                  if (!state.isNameSame) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const TextFieldEmailEditProfile(),
              const SizedBox(
                height: 24,
              ),
              BlocBuilder<EditProfileBloc, EditProfileState>(
                buildWhen: (p, c) {
                  return p.isEmailSame != c.isEmailSame;
                },
                builder: (context, state) {
                  if (!state.isEmailSame) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
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
