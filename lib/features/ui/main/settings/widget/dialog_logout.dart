import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:cling/features/ui/main/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';

Future<void> dialogLogout(BuildContext context) async {
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
                AppLocalizations.of(context)!.confirmLogout,
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 8.hmea,
              ),
              Text(
                AppLocalizations.of(context)!.wantLogout,
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontSize: 10.sp,
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
                      context.read<ProfileBloc>().add(SendLogout());
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
                          AppLocalizations.of(context)!.continueLogout,
                          style: TextStyle(
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
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
                          AppLocalizations.of(context)!.back,
                          style: TextStyle(
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
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
