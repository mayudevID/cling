// ignore_for_file: prefer_const_constructors

import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:cling/features/ui/main/add_goal/widgets/add_goal_logo_picker.dart';
import 'package:cling/injection.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../bloc/add_goal_bloc.dart';

class AddGoalPage extends StatelessWidget {
  const AddGoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddGoalBloc(
        context: context,
        dbRepo: getIt<DatabaseRepository>(),
      ),
      child: AddGoalPageContent(),
    );
  }
}

class AddGoalPageContent extends StatelessWidget {
  const AddGoalPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.wmea),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16.hmea,
              ),
              Text(
                AppLocalizations.of(context)!.addGoals,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 32.hmea,
              ),
              Center(
                child: addGoalLogoPicker(context),
              ),
              SizedBox(
                height: 24.hmea,
              ),
              Text(
                "Goals name",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 8.hmea,
              ),
              Container(
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
                child: TextFormField(
                  onChanged: (value) {
                    context.read<AddGoalBloc>().add(SetNameGoal(value));
                  },
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: "Enter Goal",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.hmea,
              ),
              BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                buildWhen: (p, c) {
                  return p.selectedCurrency.name != c.selectedCurrency.name;
                },
                builder: (context, state) {
                  return Text(
                    "Target (${state.selectedCurrency.name})",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                },
              ),
              SizedBox(
                height: 8.hmea,
              ),
              Container(
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
                    BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                      buildWhen: (p, c) {
                        return p.selectedCurrency.name !=
                            c.selectedCurrency.name;
                      },
                      builder: (context, state) {
                        return Text(
                          state.selectedCurrency.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontWeight: FontWeight.w800,
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 10.wmea,
                    ),
                    Expanded(
                      child: BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                        buildWhen: (p, c) {
                          return p.selectedCurrency.name !=
                              c.selectedCurrency.name;
                        },
                        builder: (context, state) {
                          return TextFormField(
                            inputFormatters: [
                              CurrencyTextInputFormatter(
                                locale: state.selectedCurrency.value
                                    .toLanguageTag(),
                                symbol: "",
                                decimalDigits: 2,
                              ),
                            ],
                            enableInteractiveSelection: false,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              context
                                  .read<AddGoalBloc>()
                                  .add(SetAmountInput(value));
                            },
                            cursorColor: Colors.white,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.5.sp,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration.collapsed(
                              hintText: '0',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.5.sp,
                                fontFamily: FontFamily.cabinetGrotesk,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32.hmea,
              ),
              PinkButton(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<AddGoalBloc>().add(SaveDataGoal());
                },
                name: AppLocalizations.of(context)!.submit,
              ),
              SizedBox(
                height: 16.hmea,
              ),
              BlackButton(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.pop(context);
                },
                name: AppLocalizations.of(context)!.cancel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
