import 'package:cling/core/utils.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/features/ui/main/goal_list/bloc/goal_list_bloc.dart';
import 'package:cling/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';

class GoalListPage extends StatelessWidget {
  const GoalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoalListBloc(dbRepo: getIt<DatabaseRepository>()),
      child: const GoalListPageContent(),
    );
  }
}

class GoalListPageContent extends StatelessWidget {
  const GoalListPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 16.hmea),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child:
                    Assets.lib.resources.images.fluentChevronLeft24Filled.svg(),
              ),
              SizedBox(width: 16.wmea),
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
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  AppLocalizations.of(context)!.markReadAll,
                  style: TextStyle(
                    color: Colors.blue[100],
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 16.hmea),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: _listViewBuilder(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listViewBuilder(BuildContext context) {
    return SmartRefresher(
      controller: RefreshController(),
      child: ListView.separated(
        itemBuilder: (_, context) {
          return Container();
        },
        separatorBuilder: (_, context) {
          return Container();
        },
        itemCount: 3,
      ),
    );
  }
}
