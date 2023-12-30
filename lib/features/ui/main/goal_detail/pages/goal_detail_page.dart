import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../repository/database_repository.dart';
import '../../../../repository/settings_repository.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/goal_detail_bloc.dart';
import '../widgets/add_goal_saving_bottom_sheet.dart';
import '../widgets/list_savings_and_date_container.dart';
import '../widgets/list_savings_goal.dart';
import '../widgets/logo_goal_widget.dart';
import '../widgets/target_goal_widget.dart';

class GoalDetailPage extends StatelessWidget {
  const GoalDetailPage({super.key, required this.goalModelId});
  final int goalModelId;

  static GlobalKey<NavigatorState> navKeyMain = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GoalDetailBloc(
        dbRepo: getIt<DatabaseRepository>(),
        settingsRepo: getIt<SettingsRepository>(),
      )..add(InitGoal(goalModelId)),
      child: const GoalDetailPageContent(),
    );
  }
}

class GoalDetailPageContent extends StatelessWidget {
  const GoalDetailPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: GoalDetailPage.navKeyMain,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.wmea),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 16.hmea),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Assets
                          .lib.resources.images.fluentChevronLeft24Filled
                          .svg(),
                    ),
                    SizedBox(width: 8.wmea),
                    BlocBuilder<GoalDetailBloc, GoalDetailState>(
                      builder: (context, state) {
                        return Text(
                          state.goalModel.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.5.sp,
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        final result = await dialogDelete(context);
                        if (result) {
                          // ignore: use_build_context_synchronously
                          context.read<GoalDetailBloc>().add(DeleteGoal());
                        }
                      },
                      child: Assets.lib.resources.images.jamTrash.svg(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32.hmea,
              ),
              logoGoalWidget(context),
              SizedBox(
                height: 24.hmea,
              ),
              targetGoalWidget(context),
              SizedBox(
                height: 32.hmea,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.savingDate,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 16.hmea),
              Expanded(
                child: BlocBuilder<GoalDetailBloc, GoalDetailState>(
                  buildWhen: (previous, current) {
                    return previous.dataSavingsList != current.dataSavingsList;
                  },
                  builder: (context, state) {
                    if (state.dataSavingsList.isEmpty) {
                      return const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "No Saving :(",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: FontFamily.cabinetGrotesk,
                          ),
                        ),
                      );
                    }

                    final formatCurr = context.select(
                      (LangCurrencyBloc bloc) {
                        return bloc.state.selectedLanguage.value
                            .toLanguageTag();
                      },
                    );

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.dataSavingsList.length,
                      itemBuilder: (context, idx) {
                        final itemDate = DateTime(
                          state.dataSavingsList[idx].date.year,
                          state.dataSavingsList[idx].date.month,
                          state.dataSavingsList[idx].date.day,
                        );

                        final container = savingItem(
                          context: context,
                          formatCurr: formatCurr,
                          data: state.dataSavingsList[idx],
                        );

                        final isDateDifferent = idx > 0
                            ? !itemDate.isAtSameMomentAs(
                                DateTime(
                                  state.dataSavingsList[idx - 1].date.year,
                                  state.dataSavingsList[idx - 1].date.month,
                                  state.dataSavingsList[idx - 1].date.day,
                                ),
                              )
                            : true;

                        return isDateDifferent
                            ? listSavingsWithDateContainer(
                                context,
                                itemDate,
                                container,
                              )
                            : container;
                      },
                      separatorBuilder: (cntxt, _) => SizedBox(height: 6.hmea),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.hmea),
              PinkButton(
                onTap: () => addGoalSavingBottomSheet(context),
                name: AppLocalizations.of(context)!.addSaving,
              ),
              SizedBox(height: 16.hmea),
            ],
          ),
        ),
      ),
    );
  }
}
