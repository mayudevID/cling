import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/gen/assets.gen.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../../language_currency/lang_export.dart';
import '../bloc/calc_bloc.dart';
import '../widget/build_button_calculator.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key, required this.amount});
  final double? amount;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalcBloc()..add(InitAmount(amount)),
      child: const CalculatorPageContent(),
    );
  }
}

class CalculatorPageContent extends StatelessWidget {
  const CalculatorPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context, [false]),
                    child: Assets.lib.resources.images.fluentChevronLeft24Filled
                        .svg(),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Calculator",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: BlocBuilder<CalcBloc, CalcState>(
                        buildWhen: (p, c) {
                          return p.expressionFromCount != c.expressionFromCount;
                        },
                        builder: (context, state) {
                          return Text(
                            state.expressionFromCount,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade400,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: BlocBuilder<CalcBloc, CalcState>(
                        buildWhen: (p, c) => p.listInput != c.listInput,
                        builder: (context, state) {
                          return Text(
                            state.listInput.join(),
                            style: const TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    buildButtonCalculator(context, '7'),
                    buildButtonCalculator(context, '8'),
                    buildButtonCalculator(context, '9'),
                    buildButtonCalculator(
                      context,
                      ' / ',
                      textColor: Colors.black,
                      color: Colors.amber.shade50,
                      overlayColor: Colors.black54,
                    ),
                  ],
                ),
                Row(
                  children: [
                    buildButtonCalculator(context, '4'),
                    buildButtonCalculator(context, '5'),
                    buildButtonCalculator(context, '6'),
                    buildButtonCalculator(
                      context,
                      ' * ',
                      textColor: Colors.black,
                      color: Colors.amber.shade50,
                      overlayColor: Colors.black54,
                    ),
                  ],
                ),
                Row(
                  children: [
                    buildButtonCalculator(context, '1'),
                    buildButtonCalculator(context, '2'),
                    buildButtonCalculator(context, '3'),
                    buildButtonCalculator(
                      context,
                      ' - ',
                      textColor: Colors.black,
                      color: Colors.amber.shade50,
                      overlayColor: Colors.black54,
                    ),
                  ],
                ),
                Row(
                  children: [
                    buildButtonCalculator(context, '.'),
                    buildButtonCalculator(context, '0'),
                    buildButtonCalculator(
                      context,
                      '=',
                      color: Colors.blue.shade700,
                      overlayColor: Colors.white,
                    ),
                    buildButtonCalculator(
                      context,
                      ' + ',
                      textColor: Colors.black,
                      color: Colors.amber.shade50,
                      overlayColor: Colors.black54,
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<CalcBloc>().add(
                              AddExpression(AppLocalizations.of(context)!.save),
                            );
                      },
                      child: Container(
                        height: 72,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: const BoxDecoration(color: Colors.green),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.save,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: FontFamily.cabinetGrotesk,
                            ),
                          ),
                        ),
                      ),
                    ),
                    buildButtonCalculator(
                      context,
                      'Del',
                      color: Colors.red[300]!,
                      overlayColor: Colors.white,
                    ),
                    buildButtonCalculator(
                      context,
                      'C',
                      color: Colors.red,
                      overlayColor: Colors.red[200]!,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
