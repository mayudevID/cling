import 'dart:async';

import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/auth/bloc/app_bloc.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

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
        context.read<AppBloc>().add(CheckStatus(context));
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
          width: 100.w,
          height: 100.h,
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
