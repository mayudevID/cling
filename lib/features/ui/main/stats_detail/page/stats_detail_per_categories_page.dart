import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../injection.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/detail_category_model.dart';
import '../../../../repository/database_repository.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/stats_detail_bloc.dart';
import '../widgets/change_date_by_category_widget/choose_date_range_by_category.dart';
import '../widgets/item_date_amount_widget.dart';
import '../widgets/tag_categories_with_type_flow_widget.dart';

class StatsDetailPerCategoriesPage extends StatelessWidget {
  const StatsDetailPerCategoriesPage({
    super.key,
    required DetailCategoryModel detailCategoryModel,
  }) : _detailCategoryModel = detailCategoryModel;
  final DetailCategoryModel _detailCategoryModel;

  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  StatsDetailEvent getData(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    if (_detailCategoryModel.title == appLoc.mostIncome) {
      return GetMostIncomeByCategory();
    } else if (_detailCategoryModel.title == appLoc.mostExpense) {
      return GetMostExpenseByCategory();
    } else if (_detailCategoryModel.title == appLoc.incomeBreakdown) {
      return GetIncomeBreakdownByCategory();
    } else {
      return GetExpenseBreakdownByCategory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatsDetailBloc(
        context: context,
        detailCategoryModel: _detailCategoryModel,
        dbRepo: getIt<DatabaseRepository>(),
      )..add(getData(context)),
      child: StatsDetailPerCategoriesPageContent(
        type: _detailCategoryModel.type,
        categoryOrSourceIcon: _detailCategoryModel.categoryStr.substring(
          0,
          _detailCategoryModel.categoryStr.indexOf(" "),
        ),
        categoryOrSourceClass: _detailCategoryModel.categoryStr.substring(
          _detailCategoryModel.categoryStr.indexOf(" ") + 1,
        ),
        title: _detailCategoryModel.title,
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
      key: StatsDetailPerCategoriesPage.navKey,
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
                ...chooseDateRangeByCategory(context),
                SizedBox(height: 16.hmea),
              ],
              BlocBuilder<StatsDetailBloc, StatsDetailState>(
                buildWhen: (p, c) {
                  return p.listTransactionModel != c.listTransactionModel;
                },
                builder: (context, state) {
                  return Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          return itemDateAmountWidget(
                            context,
                            state.listTransactionModel[index],
                            isIncome,
                          );
                        },
                        separatorBuilder: (_, idx) => SizedBox(height: 4.hmea),
                        itemCount: state.listTransactionModel.length,
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
