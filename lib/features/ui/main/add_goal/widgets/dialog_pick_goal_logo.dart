import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/init_database.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../bloc/add_goal_bloc.dart';

Future<void> dialogPickGoalLogo(BuildContext mainContext) async {
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
            top: 18.h,
            left: 18.w,
            right: 18.w,
            bottom: 18.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose Logo",
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                height: 400.h,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: emotLogo.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        mainContext.read<AddGoalBloc>().add(
                              SetLogoGoal(emotLogo[index]),
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
