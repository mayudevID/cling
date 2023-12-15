import 'package:cling/core/utils.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../../main_page.dart';
import '../../main_widget/change_date_widget/choose_date_range.dart';
import '../../statistics/bloc/statistics_bloc.dart';
import '../bloc/stats_detail_bloc.dart';
import '../widgets/item_date_expense_widget.dart';
import '../widgets/item_date_income_widget.dart';
import '../widgets/tag_categories_with_type_flow_widget.dart';

class StatsDetailPerCategoriesPage extends StatelessWidget {
  const StatsDetailPerCategoriesPage({
    super.key,
    required List<String> categoryOrSource,
  }) : _categoryOrSource = categoryOrSource;
  final List<String> _categoryOrSource;

  StatsDetailEvent getData(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    if (_categoryOrSource[2] == appLoc.mostIncome) {
      return GetMostIncomeByCategories(_categoryOrSource[1]);
    } else if (_categoryOrSource[2] == appLoc.mostExpense) {
      return GetMostExpenseByCategories(_categoryOrSource[1]);
    } else {
      return GetMostIncomeByCategories(_categoryOrSource[1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return StatsDetailBloc(dbRepo: getIt<DatabaseRepository>())
          ..add(getData(context));
      },
      child: BlocProvider.value(
        value: BlocProvider.of<StatisticsBloc>(
          MainPage.navKeyMain.currentContext!,
        ),
        child: StatsDetailPerCategoriesPageContent(
          type: _categoryOrSource[0],
          categoryOrSourceIcon: _categoryOrSource[1].substring(
            0,
            _categoryOrSource[1].indexOf(" "),
          ),
          categoryOrSourceClass: _categoryOrSource[1].substring(
            _categoryOrSource[1].indexOf(" ") + 1,
          ),
          title: _categoryOrSource[2],
        ),
      ),
    );
  }
}

class StatsDetailPerCategoriesPageContent extends StatelessWidget {
  const StatsDetailPerCategoriesPageContent({
    super.key,
    required String type,
    required String categoryOrSourceIcon,
    required String categoryOrSourceClass,
    required String title,
  })  : _type = type,
        _categoryOrSourceIcon = categoryOrSourceIcon,
        _categoryOrSourceClass = categoryOrSourceClass,
        _title = title;
  final String _type;
  final String _categoryOrSourceIcon;
  final String _categoryOrSourceClass;
  final String _title;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final isIncome = (_title == appLocalizations.mostIncome ||
        _title == appLocalizations.incomeBreakdown);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.wmea),
          child: Column(
            children: [
              SizedBox(height: 16.hmea),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Assets.lib.resources.images.fluentChevronLeft24Filled
                        .svg(),
                  ),
                  SizedBox(width: 16.wmea),
                  Text(
                    '${appLocalizations.detail} - $_title',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.hmea),
              tagCategoriesWithTypeFlowWidget(
                context,
                _type,
                _categoryOrSourceIcon,
                _categoryOrSourceClass,
              ),
              SizedBox(height: 16.hmea),
              if (_title == appLocalizations.incomeBreakdown ||
                  _title == appLocalizations.expenseBreakdown) ...[
                ...chooseDateRange(context),
                SizedBox(height: 16.hmea),
              ],
              BlocBuilder<StatsDetailBloc, StatsDetailState>(
                buildWhen: (p, c) {
                  if (isIncome) {
                    return p.listIncomeModel != c.listIncomeModel;
                  } else {
                    return p.listExpenseModel != c.listExpenseModel;
                  }
                },
                builder: (context, state) {
                  final itemBuilder = isIncome
                      ? (_, index) {
                          return itemDateAmountIncomeWidget(
                            context,
                            state.listIncomeModel[index],
                          );
                        }
                      : (_, index) {
                          return itemDateAmountExpenseWidget(
                            context,
                            state.listExpenseModel[index],
                          );
                        };

                  return Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: itemBuilder,
                        separatorBuilder: (_, index) {
                          return SizedBox(height: 4.hmea);
                        },
                        itemCount: (isIncome)
                            ? state.listIncomeModel.length
                            : state.listExpenseModel.length,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
