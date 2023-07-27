import 'dart:async';

import 'package:cling/core/route.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer.periodic(
      const Duration(milliseconds: 3500),
      (timer) {
        timer.cancel();
        Navigator.pushReplacementNamed(
          context,
          RouteName.onboard,
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.lib.resources.images.logo.svg(),
              SizedBox(
                height: 8.02.hmea,
              ),
              const Text(
                'Cling!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21.39,
                  fontFamily: FontFamily.bungee,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
