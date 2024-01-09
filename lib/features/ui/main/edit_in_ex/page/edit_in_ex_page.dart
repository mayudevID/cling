import 'package:cling/core/utils.dart';
import 'package:cling/features/model/income_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/route.dart';
import '../../../../../injection.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/expense_categories_model.dart';
import '../../../../model/expense_model.dart';
import '../../../../model/income_source_model.dart';
import '../../../../model/transaction_model.dart';
import '../../../../repository/database_repository.dart';
import '../../../../repository/settings_repository.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../../home/widgets/categories_row.dart';
import '../../main_widget/enum_flowtype.dart';
import '../bloc/edit_income_expense_bloc.dart';
import '../widget/datetime_edit_time.dart';
import '../widget/dropdown_edit_categories.dart';

class EditIncomeExpensePage extends StatelessWidget {
  const EditIncomeExpensePage({
    super.key,
    required this.flowType,
    required this.transactionModel,
  });
  final TransactionModel transactionModel;
  final FlowType flowType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditIncomeExpenseBloc(
        dbRepo: getIt<DatabaseRepository>(),
        settingsRepo: getIt<SettingsRepository>(),
        descOrItem: (flowType == FlowType.income)
            ? (transactionModel as IncomeModel).desc ?? ""
            : (transactionModel as ExpenseModel).item,
        amount: transactionModel.amount,
      )..add(
          (flowType == FlowType.income)
              ? GetIncomeSource(transactionModel)
              : GetExpenseCategories(transactionModel),
        ),
      child: EditIncomeExpensePageContent(flowType: flowType),
    );
  }
}

class EditIncomeExpensePageContent extends StatelessWidget {
  const EditIncomeExpensePageContent({super.key, required this.flowType});
  final FlowType flowType;

  List<DropdownMenuItem> menuItemExpense(List<ExpenseCategoriesModel> data) {
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

  List<DropdownMenuItem> menuItemIncome(List<IncomeSourceModel> data) {
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
              SizedBox(height: 16.hmea),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (flowType == FlowType.income)
                        ? AppLocalizations.of(context)!.editIncome
                        : AppLocalizations.of(context)!.editExpenses,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      context.read<EditIncomeExpenseBloc>().add(DeleteData());
                    },
                    child: Assets.lib.resources.images.jamTrash.svg(),
                  ),
                ],
              ),
              SizedBox(height: 24.hmea),
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
              datetimeEditWidget(context),
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
              dropDownEditCategories(flowType: flowType),
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
                  initialValue:
                      context.read<EditIncomeExpenseBloc>().state.descOrItem,
                  onChanged: (value) {
                    context
                        .read<EditIncomeExpenseBloc>()
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
                        context.read<EditIncomeExpenseBloc>().state.amountInput,
                  );

                  if ((amountRes! as List)[0] == true) {
                    // ignore: use_build_context_synchronously
                    context
                        .read<EditIncomeExpenseBloc>()
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
                        child: BlocBuilder<EditIncomeExpenseBloc,
                            EditIncomeExpenseState>(
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
                  context.read<EditIncomeExpenseBloc>().add(SaveData(flowType));
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
