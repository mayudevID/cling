import '../../bloc/goal_detail_bloc.dart';
import '../../pages/goal_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/init_database.dart';
import '../../../../../../resources/gen/fonts.gen.dart';

Future<void> dialogPickEditGoalLogo(BuildContext mainContext) async {
  await showDialog(
    context: mainContext,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(
            top: 18,
            left: 18,
            right: 18,
            bottom: 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Choose Logo",
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 400,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: emotLogo.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        GoalDetailPage.navKeyMain.currentContext!
                            .read<GoalDetailBloc>()
                            .add(ChangeIcon(emotLogo[index]));
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          emotLogo[index],
                          style: const TextStyle(
                            fontSize: 32,
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
