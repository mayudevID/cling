import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/route.dart';
import '../../../../../injection.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../repository/database_repository.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../../main_widget/enum_flowtype.dart';
import '../bloc/add_income_expense_bloc.dart';
import '../widget/datetime_add_time.dart';
import '../widget/dropdown_categories.dart';

class AddIncomeExpensePage extends StatelessWidget {
  const AddIncomeExpensePage({super.key, required this.flowType});
  final FlowType flowType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddIncomeExpenseBloc(
        context: context,
        dbRepo: getIt<DatabaseRepository>(),
      )..add((flowType == FlowType.income)
          ? GetIncomeSource()
          : GetExpenseCategories()),
      child: AddIncomeExpensePageContent(flowType: flowType),
    );
  }
}

class AddIncomeExpensePageContent extends StatelessWidget {
  const AddIncomeExpensePageContent({super.key, required this.flowType});
  final FlowType flowType;

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
                (flowType == FlowType.income)
                    ? AppLocalizations.of(context)!.addIncome
                    : AppLocalizations.of(context)!.addExpenses,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 24.hmea,
              ),
              Text(
                (flowType == FlowType.income)
                    ? AppLocalizations.of(context)!.date
                    : AppLocalizations.of(context)!.purchaseDate,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8.hmea),
              datetimeAddWidget(context),
              SizedBox(height: 8.hmea),
              Text(
                (flowType == FlowType.income)
                    ? AppLocalizations.of(context)!.incomeSource
                    : AppLocalizations.of(context)!.categories,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8.hmea),
              dropDownCategories(flowType: flowType),
              SizedBox(height: 8.hmea),
              Text(
                (flowType == FlowType.income)
                    ? AppLocalizations.of(context)!.descriptionOptional
                    : AppLocalizations.of(context)!.items,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8.hmea),
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
                    context
                        .read<AddIncomeExpenseBloc>()
                        .add(SetDescOrItem(value));
                  },
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: (flowType == FlowType.income)
                        ? AppLocalizations.of(context)!.descriptionOptional
                        : AppLocalizations.of(context)!.items,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.hmea),
              BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                buildWhen: (p, c) {
                  return p.selectedCurrency.name != c.selectedCurrency.name;
                },
                builder: (context, state) {
                  return Text(
                    '${AppLocalizations.of(context)!.amount} (${state.selectedCurrency.name})',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                },
              ),
              SizedBox(height: 8.hmea),
              GestureDetector(
                onTap: () async {
                  final amountRes = await Navigator.pushNamed(
                    context,
                    RouteName.calc,
                    arguments:
                        context.read<AddIncomeExpenseBloc>().state.amountInput,
                  );

                  if ((amountRes! as List)[0] == true) {
                    // ignore: use_build_context_synchronously
                    context
                        .read<AddIncomeExpenseBloc>()
                        .add(SetAmountInput((amountRes as List)[1]));
                  }
                },
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
                      SizedBox(width: 10.wmea),
                      Expanded(
                        child: BlocBuilder<AddIncomeExpenseBloc,
                            AddIncomeExpenseState>(
                          buildWhen: (p, c) {
                            return p.amountInput != c.amountInput;
                          },
                          builder: (context, state) {
                            return NominalMoneyFormatter(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontFamily: FontFamily.cabinetGrotesk,
                                fontWeight: FontWeight.w500,
                              ),
                              amount: state.amountInput,
                              isWithName: false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40.hmea,
              ),
              PinkButton(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<AddIncomeExpenseBloc>().add(SaveData(flowType));
                },
                name: AppLocalizations.of(context)!.submit,
              ),
              SizedBox(
                height: 16.hmea,
              ),
              BlackButton(
                name: AppLocalizations.of(context)!.cancel,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
