import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

import '../widgets/list_account_settings.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        fontSize: 20,
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
                        fontSize: 14,
                        fontFamily: 'Cabinet Grotesk',
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
        Text(
          'Account',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 24.hmea,
        ),
        ...listAccountSettings(),
        SizedBox(
          height: 31.hmea,
        ),
        Text(
          'General',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 24.hmea,
        ),
        Row(
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
                fontSize: 16,
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
      ],
    );
  }
}
