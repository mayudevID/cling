import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/model/expense_categories_model.dart';
import 'package:cling/features/model/income_source_model.dart';
import 'package:cling/features/ui/main/add_in_ex/bloc/add_income_expense_bloc.dart';
import 'package:cling/features/ui/main/home/widgets/categories_row.dart';
import 'package:cling/injection.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../repository/database_repository.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';

enum FlowType { income, expense }

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

  List<DropdownMenuItem> menuItemExpense(
    List<ExpenseCategoriesModel> data,
  ) {
    return data
        .map(
          (item) => DropdownMenuItem<ExpenseCategoriesModel>(
            value: item,
            child: Row(
              children: rowCategories(item.expenseCategories),
            ),
          ),
        )
        .toList();
  }

  List<DropdownMenuItem> menuItemIncome(
    List<IncomeSourceModel> data,
  ) {
    return data
        .map(
          (item) => DropdownMenuItem<IncomeSourceModel>(
            value: item,
            child: Row(
              children: rowCategories(item.incomeSource),
            ),
          ),
        )
        .toList();
  }

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
                        final now = DateTime.now();
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: now.subtract(const Duration(days: 186)),
                          lastDate: now,
                        );
                        if (pickedDate != null) {
                          // ignore: use_build_context_synchronously
                          context
                              .read<AddIncomeExpenseBloc>()
                              .add(SetDate(pickedDate));
                        }
                      },
                      child: Assets.lib.resources.images.calendar.svg(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.hmea,
              ),
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
              SizedBox(
                height: 8.hmea,
              ),
              BlocBuilder<AddIncomeExpenseBloc, AddIncomeExpenseState>(
                buildWhen: (prev, curr) {
                  switch (flowType) {
                    case FlowType.income:
                      return (prev.listInSource != curr.listInSource ||
                          prev.selectedCategories != curr.selectedCategories);
                    case FlowType.expense:
                      return (prev.listExCategories != curr.listExCategories ||
                          prev.selectedCategories != curr.selectedCategories);
                  }
                },
                builder: (context, state) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      customButton: Container(
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
                            if (state.selectedCategories ==
                                const MapEntry(0, "")) ...[
                              Text(
                                AppLocalizations.of(context)!.selectCategories,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5.sp,
                                  fontFamily: FontFamily.cabinetGrotesk,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ] else
                              ...rowCategories(
                                state.selectedCategories.value,
                              ),
                            const Spacer(),
                            Assets
                                .lib.resources.images.fluentChevronDown24Filled
                                .svg(),
                          ],
                        ),
                      ),
                      items: (flowType == FlowType.income)
                          ? menuItemIncome(
                              state.listInSource,
                            )
                          : menuItemExpense(
                              state.listExCategories,
                            ),
                      onChanged: (value) {
                        dynamic newVal;
                        switch (flowType) {
                          case FlowType.income:
                            newVal = value as IncomeSourceModel;
                            context
                                .read<AddIncomeExpenseBloc>()
                                .add(SetCategories(
                                  MapEntry(newVal.id, newVal.incomeSource),
                                ));
                            break;
                          case FlowType.expense:
                            newVal = value as ExpenseCategoriesModel;
                            context
                                .read<AddIncomeExpenseBloc>()
                                .add(SetCategories(
                                  MapEntry(newVal.id, newVal.expenseCategories),
                                ));
                            break;
                        }
                      },
                      dropdownStyleData: DropdownStyleData(
                        width: 390.wmea,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF313131),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 16.hmea,
              ),
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
              SizedBox(
                height: 16.hmea,
              ),
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
                                  .read<AddIncomeExpenseBloc>()
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
                height: 40.hmea,
              ),
              PinkButton(
                onTap: () {
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
