// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

import '../../../../core/logger.dart';

part 'calc_event.dart';
part 'calc_state.dart';

class CalcBloc extends Bloc<CalcEvent, CalcState> {
  CalcBloc({required BuildContext context})
      : _context = context,
        super(CalcState()) {
    on<AddExpression>(_addExpression);
  }

  final operate = [" / ", " * ", " + ", " - "];
  final BuildContext _context;

  void _addExpression(AddExpression event, emit) {
    final VAL = event.value;
    if ((VAL == "." || VAL == "Del") &&
        (state.listInput.length == 1 && state.listInput.first == "")) {
      return;
    }

    if (VAL == '=') {
      _countResult(event, emit);
    } else if (VAL == 'C') {
      _clearCalc(event, emit);
    } else if (VAL == 'Del') {
      _deleteCalc(event, emit);
    } else if (VAL == AppLocalizations.of(_context)!.save) {
      _saveValue(event, emit);
    } else {
      _addValue(event, emit);
    }
  }

  void _countResult(event, emit) {
    try {
      final joiningStr = state.listInput.join();
      Parser parser = Parser();
      Expression expression = parser.parse(joiningStr.replaceAll(",", ""));
      ContextModel contextModel = ContextModel();
      double result = expression.evaluate(EvaluationType.REAL, contextModel);

      String res = NumberFormat.currency(
        decimalDigits: (result % 1 == 0) ? 0 : 2,
        name: "",
      ).format(result);

      res = (result % 1 != 0) && (res[res.length - 1] == "0")
          ? res.substring(0, res.length - 1)
          : res;

      Logger.Green.log(res);

      emit(
        state.copyWith(
          listInput: [res],
          expressionFromCount: joiningStr,
        ),
      );
    } catch (e) {
      emit(state.copyWith(listInput: ["Error"]));
    }
  }

  void _clearCalc(event, emit) {
    emit(state.copyWith(listInput: [""], expressionFromCount: ""));
  }

  void _deleteCalc(event, emit) {
    var listInput = state.listInput.toList(growable: true);
    String lastIndex = listInput[listInput.length - 1];
    if (operate.contains(lastIndex)) {
      listInput.removeLast();
    } else {
      String newLast = lastIndex.substring(0, lastIndex.length - 1);
      if (newLast == "" && listInput.length >= 2) {
        listInput.removeLast();
      } else if (newLast == "" && listInput.length == 1) {
        listInput[0] = "";
      } else {
        if (!newLast.contains(".")) {
          newLast = NumberFormat.currency(
            decimalDigits: 0,
            name: "",
          ).format(double.parse(newLast.replaceAll(",", "")));
        }
        listInput[listInput.length - 1] = newLast;
      }
    }
    emit(state.copyWith(listInput: listInput));
  }

  void _addValue(event, emit) {
    final VAL = event.value;
    var listInput = state.listInput.toList(growable: true);
    final someVal = operate.contains(VAL);
    if (someVal) {
      listInput.addAll([VAL, ""]);
    } else {
      String last = listInput[listInput.length - 1];
      if ((last.contains(VAL) && VAL == ".") ||
          (last.length >= 3 && last[last.length - 3] == ".")) {
        return;
      }
      last += VAL;
      if (!last.contains(".")) {
        last = NumberFormat.currency(
          decimalDigits: 0,
          name: "",
        ).format(double.parse(last.replaceAll(",", "")));
      }
      listInput[listInput.length - 1] = last;
      Logger.Red.log(last);
    }
    emit(state.copyWith(listInput: listInput));
  }

  void _saveValue(event, emit) {
    final listInput = state.listInput;
    if (listInput.length == 1 &&
        (listInput.first != "Error" || listInput.first != "")) {
      Navigator.pop(_context, [true, listInput.first]);
    }
  }
}
