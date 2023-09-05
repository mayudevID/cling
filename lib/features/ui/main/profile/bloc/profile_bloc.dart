import 'package:cling/core/common_widget.dart';
import 'package:cling/core/exception.dart';
import 'package:cling/features/model/user_model.dart';
import 'package:cling/features/ui/auth/bloc/app_bloc.dart';
import 'package:cling/features/ui/main/main_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repository/auth_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required AuthRepository authRepo})
      : _authRepo = authRepo,
        super(ProfileState()) {
    on<SendLogout>(_sendLogout);
    on<GetProfile>(_getProfile);
  }

  final AuthRepository _authRepo;
  var context = MainPage.navigatorKeyMain.currentContext;

  void _sendLogout(event, emit) async {
    try {
      Navigator.pop(context!);
      loadingAuth(context!);
      await _authRepo.logOut().then((value) {
        context!.read<AppBloc>().add(const Redirect());
      });
    } on LogOutFailure catch (_) {
      errorSnackbar(
        context!,
        "Error Logout",
      );
    }
  }

  void _getProfile(
    GetProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(userModel: _authRepo.currentUserModel));
  }
}
