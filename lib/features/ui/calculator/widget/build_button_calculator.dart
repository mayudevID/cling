import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    height: 72.h,
    child: ElevatedButton(
      onPressed: () => context.read<CalcBloc>().add(AddExpression(value)),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(color),
        overlayColor: WidgetStateProperty.all(overlayColor),
        shape: WidgetStateProperty.all(
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
