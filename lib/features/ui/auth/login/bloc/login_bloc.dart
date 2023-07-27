import 'package:cling/core/exception.dart';
import 'package:cling/features/repository/auth_repository.dart';
import 'package:cling/features/ui/auth/bloc/app_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../onboard/widgets/animation_onboard.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authRepository) : super(LoginState()) {
    on<ToggleEye>(_toggleEye);
    on<ChangeEmail>(_changeEmail);
    on<ChangePassword>(_changePassword);
    on<SendLogin>(_sendLogin);
  }

  final AuthRepository _authRepository;

  void _toggleEye(ToggleEye event, Emitter<LoginState> emit) {
    emit(state.copyWith(isObscure: !state.isObscure));
  }

  void _changeEmail(ChangeEmail event, emit) {
    emit(state.copyWith(email: event.email));
  }

  void _changePassword(ChangePassword event, emit) {
    emit(state.copyWith(password: event.password));
  }

  void _sendLogin(SendLogin event, emit) async {
    if (!EmailValidator.validate(state.email)) {
      errorSnackbar(event.context, "Email not valid");
      return;
    }

    if (state.password.trim().length < 8 || state.password.trim().isEmpty) {
      errorSnackbar(event.context, "Password must be 8 character or more");
      return;
    }

    emit(state.copyWith(status: LoginStatus.load));

    try {
      await _authRepository.logInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );

      AnimationOnboard.animC1.dispose();
      AnimationOnboard.animC2.dispose();
      AnimationOnboard.animC3.dispose();
      AnimationOnboard.animC4.dispose();
      await Future.delayed(const Duration(milliseconds: 250));

      emit(state.copyWith(status: LoginStatus.success));

      Future.microtask(() {
        event.context.read<AppBloc>().add(CheckStatus(event.context));
      });
    } on LogInWithEmailAndPasswordFailure catch (e, _) {
      errorSnackbar(event.context, e.message);
      emit(state.copyWith(status: LoginStatus.init));
    }
  }
}
