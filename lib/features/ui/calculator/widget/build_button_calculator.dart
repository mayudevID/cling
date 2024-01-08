import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../resources/gen/fonts.gen.dart';
import '../bloc/calc_bloc.dart';

Widget buildButtonCalculator(
  BuildContext context,
  String value, {
  Color color = Colors.black,
  Color overlayColor = Colors.grey,
  Color textColor = Colors.white,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 4,
    height: 72.hmea,
    child: ElevatedButton(
      onPressed: () => context.read<CalcBloc>().add(AddExpression(value)),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        overlayColor: MaterialStateProperty.all(overlayColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 20.sp,
          color: textColor,
          fontWeight: FontWeight.w500,
          fontFamily: FontFamily.cabinetGrotesk,
        ),
      ),
    ),
  );
}
