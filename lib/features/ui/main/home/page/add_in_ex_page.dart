import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/model/expense_categories_model.dart';
import 'package:cling/features/model/income_source_model.dart';
import 'package:cling/features/ui/main/home/bloc/home_bloc.dart';
import 'package:cling/features/ui/main/home/widgets/categories_row.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../../bloc/main_bloc.dart';

enum FlowType { income, expense }

class AddIncomeExpensePage extends StatelessWidget {
  const AddIncomeExpensePage({super.key, required this.flowType});
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.wmea),
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
              fontSize: 22.sp,
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
              fontSize: 12.sp,
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
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (prev, curr) {
                    return prev.selectedDate != curr.selectedDate;
                  },
                  builder: (context, state) {
                    final day = state.selectedDate.day;
                    final month = state.selectedDate.month;
                    final year = state.selectedDate.year;
                    return Text(
                      '$day/$month/$year',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5.sp,
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
                      firstDate: DateTime(now.year, now.month, 1),
                      lastDate: now,
                    );
                    if (pickedDate != null) {
                      Future.microtask(() {
                        context.read<HomeBloc>().add(SetDate(pickedDate));
                      });
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
              fontSize: 12.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(
            height: 8.hmea,
          ),
          BlocBuilder<HomeBloc, HomeState>(
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
                              fontSize: 12.5.sp,
                              fontFamily: FontFamily.cabinetGrotesk,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ] else
                          ...rowCategories(
                            state.selectedCategories.value,
                          ),
                        const Spacer(),
                        Assets.lib.resources.images.fluentChevronDown24Filled
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
                        context.read<HomeBloc>().add(SetCategories(
                              MapEntry(newVal.id, newVal.incomeSource),
                            ));
                        break;
                      case FlowType.expense:
                        newVal = value as ExpenseCategoriesModel;
                        context.read<HomeBloc>().add(SetCategories(
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
              fontSize: 12.sp,
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
                context.read<HomeBloc>().add(SetDescOrItem(value));
              },
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration.collapsed(
                hintText: (flowType == FlowType.income)
                    ? AppLocalizations.of(context)!.descriptionOptional
                    : AppLocalizations.of(context)!.items,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.5.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.hmea,
          ),
          Text(
            '${AppLocalizations.of(context)!.amount} (IDR)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
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
                Text(
                  'IDR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  width: 10.wmea,
                ),
                Expanded(
                  child: TextFormField(
                    inputFormatters: [
                      CurrencyTextInputFormatter(
                        locale: "id",
                        symbol: "",
                        decimalDigits: 0,
                      ),
                    ],
                    enableInteractiveSelection: false,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      context.read<HomeBloc>().add(SetAmountInput(value));
                    },
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
              context.read<HomeBloc>().add(SaveData(flowType));
            },
            name: AppLocalizations.of(context)!.submit,
          ),
          SizedBox(
            height: 16.hmea,
          ),
          BlackButton(
            name: AppLocalizations.of(context)!.cancel,
            onTap: () {
              context.read<MainBloc>().add(
                    const TabChange(
                      tabIndex: 0,
                    ),
                  );
              context.read<HomeBloc>().add(ClearDataForm());
            },
          ),
        ],
      ),
    );
  }
}
