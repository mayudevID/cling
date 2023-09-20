import 'package:cling/core/common_widget.dart';
import 'package:cling/core/exception.dart';
import 'package:cling/features/model/currency.dart';
import 'package:cling/features/model/user_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/features/ui/main/main_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repository/auth_repository.dart';
import '../../../app_bloc/app_bloc.dart';
import '../../../language_currency/lang_currency_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required AuthRepository authRepo,
    required DatabaseRepository dbRepo,
  })  : _authRepo = authRepo,
        _dbRepo = dbRepo,
        super(ProfileState()) {
    on<SendLogout>(_sendLogout);
    on<GetProfile>(_getProfile);
    on<GetVerifiedStatus>(_getVerifiedStatus);
  }

  final AuthRepository _authRepo;
  final DatabaseRepository _dbRepo;
  var mainContext = MainPage.navKeyMain.currentContext!;

  void _sendLogout(event, emit) async {
    try {
      Navigator.pop(mainContext);
      loadingAuth(mainContext);
      Future.wait([
        _authRepo.logOut(),
        _dbRepo.deleteAllTable(),
      ]).then((_) async {
        mainContext.read<AppBloc>().add(const Redirect());
        await Future.delayed(const Duration(milliseconds: 100));
        // ignore: use_build_context_synchronously
        mainContext.read<LangCurrencyBloc>().add(
              const ChangeCurrency(
                selectedCurrency: Currency.idr,
              ),
            );
      });
    } on LogOutFailure catch (_) {
      errorSnackbar(
        mainContext,
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

  void _getVerifiedStatus(event, emit) {
    final isVerified = (_authRepo.currentUserSupabase!.emailConfirmedAt == null)
        ? false
        : true;
    emit(state.copyWith(isVerified: isVerified));
  }
}
