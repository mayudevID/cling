import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';

Future<void> dialogCloseVerifOnboard(BuildContext context) async {
  await showDialog(
    context: context,
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
                "Close",
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
              Text(
                "Are you sure want to close? Monthly budget and Monthly Income will be empty.",
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 12.hmea,
              ),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.hmea),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.wmea,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.hmea),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Back",
                          style: TextStyle(
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
