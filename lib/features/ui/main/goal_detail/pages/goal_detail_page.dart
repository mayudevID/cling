import 'package:flutter/services.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../repository/database_repository.dart';
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
      create: (_) => GoalDetailBloc(dbRepo: getIt<DatabaseRepository>())
        ..add(InitGoal(goalModelId)),
      child: const GoalDetailPageContent(),
    );
  }
}

class GoalDetailPageContent extends StatelessWidget {
  const GoalDetailPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        key: GoalDetailPage.navKeyMain,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Assets
                            .lib.resources.images.fluentChevronLeft24Filled
                            .svg(),
                      ),
                      const SizedBox(width: 8),
                      BlocBuilder<GoalDetailBloc, GoalDetailState>(
                        builder: (context, state) {
                          return Text(
                            state.goalModel.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.5,
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
                const SizedBox(
                  height: 32,
                ),
                logoGoalWidget(context),
                const SizedBox(
                  height: 24,
                ),
                targetGoalWidget(context),
                const SizedBox(
                  height: 32,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.savingDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<GoalDetailBloc, GoalDetailState>(
                    buildWhen: (previous, current) {
                      return previous.dataSavingsList !=
                          current.dataSavingsList;
                    },
                    builder: (context, state) {
                      if (state.dataSavingsList.isEmpty) {
                        return const Align(
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
                        separatorBuilder: (cntxt, _) =>
                            const SizedBox(height: 6),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                PinkButton(
                  onTap: () => addGoalSavingBottomSheet(context),
                  name: AppLocalizations.of(context)!.addSaving,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
