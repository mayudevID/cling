// ignore_for_file: use_buildmainContext_synchronously, use_build_context_synchronously
import 'package:cling/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/logger.dart';
import '../../../../model/goal_model.dart';
import '../../../../repository/database_repository.dart';
import '../../../language_currency/lang_export.dart';
import '../../main_widget/dialog_add_success.dart';
import '../../home/bloc/home_bloc.dart';

part 'add_goal_event.dart';
part 'add_goal_state.dart';

class AddGoalBloc extends Bloc<AddGoalEvent, AddGoalState> {
  AddGoalBloc({
    required DatabaseRepository dbRepo,
  })  : _dbRepo = dbRepo,
        super(AddGoalState()) {
    on<SetNameGoal>(_setNameGoal);
    on<SetLogoGoal>(_setLogoGoal);
    on<SaveDataGoal>(_saveDataGoal);
    on<SetAmountInput>(_setAmountInput);
  }

  final DatabaseRepository _dbRepo;
  var mainContext = MainApp.navKeyGlobal.currentContext!;

  void _setNameGoal(SetNameGoal event, Emitter<AddGoalState> emit) {
    emit(state.copyWith(nameGoal: event.nameGoal));
  }

  void _setLogoGoal(SetLogoGoal event, Emitter<AddGoalState> emit) {
    emit(state.copyWith(logoGoal: event.logoGoal));
  }

  void _setAmountInput(SetAmountInput event, Emitter<AddGoalState> emit) {
    emit(state.copyWith(amountInput: event.amountInput));
  }

  void _saveDataGoal(SaveDataGoal event, Emitter<AddGoalState> emit) async {
    if (state.logoGoal.trim().isEmpty) {
      errorToast(AppLocalizations.of(mainContext)!.pleaseSelectLogo);
      return;
    }

    if (state.nameGoal.trim().isEmpty) {
      errorToast(AppLocalizations.of(mainContext)!.pleaseFillName);
      return;
    }

    if (state.amountInput == 0) {
      errorToast(AppLocalizations.of(mainContext)!.pleaseFillAmount);
      return;
    }

    try {
      final goalData = GoalModel(
        name: state.nameGoal.trim(),
        image: state.logoGoal,
        target: state.amountInput,
        collected: 0,
      );
      await _dbRepo.insertGoal(goalData);
      mainContext.read<HomeBloc>().add(GetGoalsHomeWithCount());

      dialogAddSuccess(mainContext, null);
    } on FormatException {
      errorToast(AppLocalizations.of(mainContext)!.invalidAmount);
    } on DatabaseException catch (e) {
      errorToast(e.toString());
      Logger.Red.log(e.toString());
    }
  }
}
