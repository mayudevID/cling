import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/expense_categories_model.dart';
import '../../../../model/income_source_model.dart';
import '../../../language_currency/lang_export.dart';
import '../../home/widgets/categories_row.dart';
import '../../main_widget/enum_flowtype.dart';
import '../bloc/add_income_expense_bloc.dart';

Widget dropDownCategories({required FlowType flowType}) {
  return BlocBuilder<AddIncomeExpenseBloc, AddIncomeExpenseState>(
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
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            child: Row(
              children: [
                if (state.selectedCategories == const MapEntry(0, "")) ...[
                  Text(
                    AppLocalizations.of(context)!.selectCategories,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ] else
                  ...rowCategories(
                    state.selectedCategories.value,
                  ),
                const Spacer(),
                Assets.lib.resources.images.fluentChevronDown24Filled.svg(),
              ],
            ),
          ),
          items: (flowType == FlowType.income)
              ? menuItemIncome(state.listInSource)
              : menuItemExpense(state.listExCategories),
          onChanged: (value) {
            dynamic newVal;
            switch (flowType) {
              case FlowType.income:
                newVal = value as IncomeSourceModel;
                context.read<AddIncomeExpenseBloc>().add(SetCategories(
                      MapEntry(newVal.id, newVal.incomeSource),
                    ));
                break;
              case FlowType.expense:
                newVal = value as ExpenseCategoriesModel;
                context.read<AddIncomeExpenseBloc>().add(SetCategories(
                      MapEntry(newVal.id, newVal.expenseCategories),
                    ));
                break;
            }
          },
          dropdownStyleData: DropdownStyleData(
            width: 390,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF313131),
            ),
          ),
        ),
      );
    },
  );
}

List<DropdownItem> menuItemExpense(List<ExpenseCategoriesModel> data) {
  return data
      .map(
        (item) => DropdownItem<ExpenseCategoriesModel>(
          value: item,
          child: Row(
            children: rowCategories(item.expenseCategories),
          ),
        ),
      )
      .toList();
}

List<DropdownItem> menuItemIncome(List<IncomeSourceModel> data) {
  return data
      .map(
        (item) => DropdownItem<IncomeSourceModel>(
          value: item,
          child: Row(
            children: rowCategories(item.incomeSource),
          ),
        ),
      )
      .toList();
}
