// ignore_for_file: unused_import

import '../../../../../core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../bloc/transaction_bloc.dart';
import 'dart:math' as math;

Widget switchDateTransaction(BuildContext context) {
  final formatCurr = context.select(
    (LangCurrencyBloc bloc) {
      return bloc.state.selectedLanguage.value.toLanguageTag();
    },
  );

  return Row(
    children: [
      GestureDetector(
        onTap: () {
          context.read<TransactionBloc>().add(ClickLeft());
        },
        child: Assets.lib.resources.images.fluentChevronLeft24Filled.svg(),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0x3D787880),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      DateFormat.yMMMM(formatCurr).format(state.date),
                      key: ValueKey<String>(state.date.toString()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: FontFamily.cabinetGrotesk,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      GestureDetector(
        onTap: () {
          context.read<TransactionBloc>().add(ClickRight());
        },
        child: Transform.rotate(
          angle: math.pi,
          child: Assets.lib.resources.images.fluentChevronLeft24Filled.svg(),
        ),
      ),
    ],
  );
}
