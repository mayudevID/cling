import 'package:cling/features/ui/main/goal_list/widget/goal_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../injection.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../repository/database_repository.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/goal_list_bloc.dart';

class GoalListPage extends StatelessWidget {
  const GoalListPage({super.key});

  static GlobalKey<NavigatorState> keyState = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoalListBloc(dbRepo: getIt<DatabaseRepository>())
        ..add(GetGoalsList()),
      child: const GoalListPageContent(),
    );
  }
}

class GoalListPageContent extends StatelessWidget {
  const GoalListPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: GoalListPage.keyState,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Assets.lib.resources.images.fluentChevronLeft24Filled
                        .svg(),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    AppLocalizations.of(context)!.goals,
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
              SizedBox(height: 16.h),
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: _listViewBuilder(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listViewBuilder(BuildContext context) {
    return BlocBuilder<GoalListBloc, GoalListState>(
      buildWhen: (p, c) {
        return p.listGoalModel != c.listGoalModel ||
            p.refreshController != c.refreshController;
      },
      builder: (context, state) {
        return SmartRefresher(
          enablePullUp: true,
          enablePullDown: false,
          controller: state.refreshController,
          onLoading: () {},
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              Widget body;
              const styleText = TextStyle(
                color: Colors.white,
                fontFamily: FontFamily.cabinetGrotesk,
              );
              switch (mode) {
                case null:
                  body = const Text("EMPTY", style: styleText);
                  break;
                case LoadStatus.idle:
                  body = const Text("~~~", style: styleText);
                  break;
                case LoadStatus.canLoading:
                  body = const Text("Can load...", style: styleText);
                  break;
                case LoadStatus.loading:
                  body = const CircularProgressIndicator(color: Colors.white);
                  break;
                case LoadStatus.noMore:
                  body = Text(
                    AppLocalizations.of(context)!.noMore,
                    style: styleText,
                  );
                  break;
                case LoadStatus.failed:
                  body = const Text("Error.", style: styleText);
                  break;
              }

              return SizedBox(
                height: 55.h,
                child: Center(child: body),
              );
            },
          ),
          child: ListView.separated(
            itemCount: state.listGoalModel.length,
            itemBuilder: (context, index) {
              return goalListWidget(context, state.listGoalModel[index]);
            },
            separatorBuilder: (_, x) => SizedBox(height: 8.h),
          ),
        );
      },
    );
  }
}
