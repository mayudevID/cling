import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState()) {
    on<ToggleEyePass>(_toggleEyePass);
    on<ToggleEyeConfirmPass>(_toggleEyeConfirmPass);
  }

  void _toggleEyePass(
    ToggleEyePass event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        isEnableObscurePass: !state.isEnableObscurePass,
      ),
    );
  }

  void _toggleEyeConfirmPass(
    ToggleEyeConfirmPass event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        isEnableObscureConfirmPass: !state.isEnableObscureConfirmPass,
      ),
    );
  }
}
