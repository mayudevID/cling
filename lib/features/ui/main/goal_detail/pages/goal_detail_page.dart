import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/model/goal_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/features/ui/main/goal_detail/widgets/add_goal_saving_bottom_sheet.dart';
import 'package:cling/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../bloc/goal_detail_bloc.dart';
import '../widgets/edit_goal_logo_picker.dart';
import '../widgets/target_goal_widget.dart';

class GoalDetailPage extends StatelessWidget {
  const GoalDetailPage({super.key, required this.goalModel});
  final GoalModel goalModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GoalDetailBloc(
        dbRepo: getIt<DatabaseRepository>(),
      )..add(InitGoal(goalModel)),
      child: const GoalDetailPageContent(),
    );
  }
}

class GoalDetailPageContent extends StatelessWidget {
  const GoalDetailPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    SizedBox(
                      width: 8.wmea,
                    ),
                    BlocBuilder<GoalDetailBloc, GoalDetailState>(
                      builder: (context, state) {
                        return Text(
                          state.goalModel.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 32.hmea,
              ),
              editGoalLogoPicker(context),
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
                  "Saving History",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 16.hmea,
              ),
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
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.wmea,
                            vertical: 16.wmea,
                          ),
                          decoration: ShapeDecoration(
                            color: const Color(0x3D787880),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat.yMd(formatCurr).format(
                                  DateTime.parse(
                                    state.dataSavingsList[index]['Date']
                                        .toString(),
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5.sp,
                                  fontFamily: FontFamily.cabinetGrotesk,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              NominalMoneyFormatter(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5.sp,
                                  fontFamily: FontFamily.cabinetGrotesk,
                                  fontWeight: FontWeight.w700,
                                ),
                                amount: double.parse(state
                                    .dataSavingsList[index]['TotalSavings']
                                    .toString()),
                                decimalDigits: 2,
                                isWithName: true,
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16.hmea);
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 16.hmea,
              ),
              PinkButton(
                onTap: () {
                  addGoalSavingBottomSheet(context);
                },
                name: "Add Saving",
              ),
              SizedBox(
                height: 16.hmea,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
