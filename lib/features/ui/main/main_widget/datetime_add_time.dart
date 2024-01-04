import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../resources/gen/assets.gen.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../../language_currency/lang_currency_bloc.dart';
import '../add_in_ex/bloc/add_income_expense_bloc.dart';

Widget datetimeAddWidget(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Container(
          decoration: ShapeDecoration(
            color: const Color(0xFF313131),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 16.hmea,
            horizontal: 16.wmea,
          ),
          child: Row(
            children: [
              BlocBuilder<AddIncomeExpenseBloc, AddIncomeExpenseState>(
                buildWhen: (prev, curr) {
                  return prev.selectedDate != curr.selectedDate;
                },
                builder: (context, state) {
                  final date = DateFormat.yMd(
                    context.select(
                      (LangCurrencyBloc bloc) {
                        return bloc.state.selectedLanguage.value
                            .toLanguageTag();
                      },
                    ),
                  ).format(state.selectedDate);

                  return Text(
                    date,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  final now =
                      context.read<AddIncomeExpenseBloc>().state.selectedDate;
                  DateTime? pickDate = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: now.subtract(const Duration(days: 186)),
                    lastDate: now,
                  );
                  if (pickDate != null) {
                    // ignore: use_build_context_synchronously
                    context.read<AddIncomeExpenseBloc>().add(SetDate(pickDate));
                  }
                },
                child: Assets.lib.resources.images.calendar.svg(),
              ),
            ],
          ),
        ),
      ),
      SizedBox(width: 16.wmea),
      Expanded(
        child: Container(
          decoration: ShapeDecoration(
            color: const Color(0xFF313131),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 16.hmea,
            horizontal: 16.wmea,
          ),
          child: Row(
            children: [
              BlocBuilder<AddIncomeExpenseBloc, AddIncomeExpenseState>(
                buildWhen: (prev, curr) {
                  return prev.selectedDate != curr.selectedDate;
                },
                builder: (context, state) {
                  final date = DateFormat.jm(
                    context.select(
                      (LangCurrencyBloc bloc) {
                        return bloc.state.selectedLanguage.value
                            .toLanguageTag();
                      },
                    ),
                  ).format(state.selectedDate);

                  return Text(
                    date,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  final now =
                      context.read<AddIncomeExpenseBloc>().state.selectedDate;
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(now),
                  );
                  if (pickedTime != null) {
                    final now = DateTime.now();
                    final dateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    // ignore: use_build_context_synchronously
                    context.read<AddIncomeExpenseBloc>().add(SetTime(dateTime));
                  }
                },
                child: const Icon(
                  Icons.access_time,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    ],
  );
}
