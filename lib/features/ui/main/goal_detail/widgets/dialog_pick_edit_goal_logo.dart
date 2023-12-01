import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/main/goal_detail/bloc/goal_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/init_database.dart';
import '../../../../../resources/gen/fonts.gen.dart';

Future<void> dialogPickEditGoalLogo(BuildContext mainContext) async {
  await showDialog(
    context: mainContext,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(
            top: 18.hmea,
            left: 18.wmea,
            right: 18.wmea,
            bottom: 18.hmea,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose Logo",
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 8.hmea,
              ),
              SizedBox(
                height: 400.hmea,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: emotLogo.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        mainContext.read<GoalDetailBloc>().add(
                              ChangeIcon(emotLogo[index]),
                            );
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          emotLogo[index],
                          style: TextStyle(
                            fontSize: 32.sp,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
