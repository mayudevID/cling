import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/main/profile/widgets/dialog_logout.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../widgets/list_account_settings.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.wmea),
      child: Column(
        children: [
          SizedBox(
            height: 31.hmea,
          ),
          Container(
            padding: EdgeInsets.all(16.wmea),
            decoration: ShapeDecoration(
              color: const Color(0x3D787880),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jane Cooper",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 8.hmea,
                      ),
                      Text(
                        'janecooper@mail.com',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5.sp,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
                Assets.lib.resources.images.editBig.svg(),
              ],
            ),
          ),
          SizedBox(
            height: 31.hmea,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 24.hmea,
          ),
          ...listAccountSettings(context),
          SizedBox(
            height: 31.hmea,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'General',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 24.hmea,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 8.wmea,
              ),
              Assets.lib.resources.images.fluentStar24Filled.svg(),
              SizedBox(
                width: 10.wmea,
              ),
              Text(
                'Rate Cling App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Assets.lib.resources.images.chevronRight16.svg(),
              SizedBox(
                width: 8.wmea,
              ),
            ],
          ),
          SizedBox(
            height: 40.hmea,
          ),
          SizedBox(
            width: 390.wmea,
            height: 57.hmea,
            child: ElevatedButton(
              onPressed: () {
                dialogLogout(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color(0xFFF8312F),
                ),
                overlayColor: MaterialStateProperty.all(
                  Colors.redAccent,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: Text(
                "Logout",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.5.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
