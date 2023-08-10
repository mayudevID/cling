import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'verification_onboard_event.dart';
part 'verification_onboard_state.dart';

class VerificationOnboardBloc
    extends Bloc<VerificationOnboardEvent, VerificationOnboardState> {
  VerificationOnboardBloc()
      : super(VerificationOnboardState(
          state: VerifOnboardPos.income,
          monBudgetIncome: 0,
          monBudgetSpent: 0,
        )) {
    on<SetIncome>(_setIncome);
    on<SetSpent>(_setSpent);
  }

  void _setIncome(event, emit) {}
  void _setSpent(event, emit) {}
}
