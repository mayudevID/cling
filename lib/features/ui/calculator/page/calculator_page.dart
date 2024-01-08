import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../resources/gen/assets.gen.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../bloc/calc_bloc.dart';
import '../widget/build_button_calculator.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalcBloc(),
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
            SizedBox(height: 16.hmea),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.wmea),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Assets.lib.resources.images.fluentChevronLeft24Filled
                        .svg(),
                  ),
                  SizedBox(width: 16.wmea),
                  Text(
                    "Calculator",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
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
                              fontSize: 16.sp,
                              color: Colors.grey.shade400,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 24.hmea),
                    Align(
                      alignment: Alignment.centerRight,
                      child: BlocBuilder<CalcBloc, CalcState>(
                        buildWhen: (p, c) => p.listInput != c.listInput,
                        builder: (context, state) {
                          return Text(
                            state.listInput.join(),
                            style: TextStyle(
                              fontSize: 24.0.sp,
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
            const Divider(),
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
                    Container(
                      height: 72.hmea,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.save,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: FontFamily.cabinetGrotesk,
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
