import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Text(
                (flowType == FlowType.income)
                    ? AppLocalizations.of(context)!.addIncome
                    : AppLocalizations.of(context)!.addExpenses,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                (flowType == FlowType.income)
                    ? AppLocalizations.of(context)!.date
                    : AppLocalizations.of(context)!.purchaseDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              datetimeAddWidget(context),
              const SizedBox(height: 8),
              Text(
                (flowType == FlowType.income)
                    ? AppLocalizations.of(context)!.incomeSource
                    : AppLocalizations.of(context)!.categories,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              dropDownCategories(flowType: flowType),
              const SizedBox(height: 8),
              Text(
                (flowType == FlowType.income)
                    ? AppLocalizations.of(context)!.descriptionOptional
                    : AppLocalizations.of(context)!.items,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: ShapeDecoration(
                  color: const Color(0xFF313131),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                child: TextFormField(
                  onChanged: (value) {
                    context
                        .read<AddIncomeExpenseBloc>()
                        .add(SetDescOrItem(value));
                  },
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: (flowType == FlowType.income)
                        ? AppLocalizations.of(context)!.descriptionOptional
                        : AppLocalizations.of(context)!.items,
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12.5,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                buildWhen: (p, c) {
                  return p.selectedCurrency.name != c.selectedCurrency.name;
                },
                builder: (context, state) {
                  return Text(
                    '${AppLocalizations.of(context)!.amount} (${state.selectedCurrency.name})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w800,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: BlocBuilder<AddIncomeExpenseBloc,
                            AddIncomeExpenseState>(
                          buildWhen: (p, c) {
                            return p.amountInput != c.amountInput;
                          },
                          builder: (context, state) {
                            return NominalMoneyFormatter(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
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
              const SizedBox(
                height: 40,
              ),
              PinkButton(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<AddIncomeExpenseBloc>().add(SaveData(flowType));
                },
                name: AppLocalizations.of(context)!.submit,
              ),
              const SizedBox(
                height: 16,
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
