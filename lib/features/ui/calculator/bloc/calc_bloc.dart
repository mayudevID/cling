// ignore_for_file: unused_local_variable, non_constant_identifier_names, use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

import '../../../../core/logger.dart';
import '../../language_currency/lang_export.dart';

part 'calc_event.dart';
part 'calc_state.dart';

class CalcBloc extends Bloc<CalcEvent, CalcState> {
  CalcBloc({
    required BuildContext context,
  })  : _context = context,
        super(CalcState()) {
    on<InitAmount>(_initAmount);
    on<AddExpression>(_addExpression);
  }

  final operate = [" / ", " * ", " + ", " - "];
  final operateError = ["Error", ""];
  final BuildContext _context;

  void _initAmount(InitAmount event, emit) {
    if (event.amount != null && event.amount != 0) {
      Logger.Red.log(event.amount);
      String initA = NumberFormat.currency(
        decimalDigits: (event.amount! % 1 == 0) ? 0 : 2,
        name: "",
      ).format(event.amount);

      if ((event.amount! % 1 != 0) && (initA[initA.length - 1] == "0")) {
        initA = initA.substring(0, initA.length - 1);
      }

      emit(state.copyWith(listInput: [initA]));
    }
  }

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

      if ((result % 1 != 0) && (res[res.length - 1] == "0")) {
        res = res.substring(0, res.length - 1);
      }

      if (res == "∞" || res == "NaN") throw Exception;

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

    if (operate.contains(VAL)) {
      listInput.addAll([VAL, ""]);
    } else {
      String last = listInput[listInput.length - 1];

      if ((last.contains(VAL) && VAL == ".") ||
          (last.length >= 3 && last[last.length - 3] == ".") ||
          last == "Error") {
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

  void _saveValue(event, emit) async {
    if (state.listInput.length == 1 &&
        !operateError.contains(state.listInput.first)) {
      Navigator.pop(_context, [
        true,
        double.parse(state.listInput.first.replaceAll(",", "")),
      ]);
    } else {
      _countResult(event, emit);
      await Future.delayed(const Duration(milliseconds: 200));
      if (!operateError.contains(state.listInput.first)) {
        Navigator.pop(_context, [
          true,
          double.parse(state.listInput.first.replaceAll(",", "")),
        ]);
      }
    }
  }
}
