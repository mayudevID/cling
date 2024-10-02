import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_currency_bloc.dart';

Widget tagCurrency(BuildContext context) {
  return BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
    builder: (context, state) {
      return Text(
        state.selectedCurrency.name,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: Colors.white,
          fontSize: 9.5.sp,
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.w500,
        ),
      );
    },
  );
}
