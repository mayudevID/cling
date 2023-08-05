import 'dart:async';

import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../injection.dart';
import '../../../main.dart';
import '../../../resources/gen/assets.gen.dart';
import '../../../resources/gen/fonts.gen.dart';
import '../auth/bloc/app_bloc.dart';

class SplashContent extends StatefulWidget {
  const SplashContent({super.key});

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent>
    with TickerProviderStateMixin {
  final String nameApp = 'Cling!';

  late final _styleText = TextStyle(
    color: Colors.white,
    fontSize: 17.sp,
    fontFamily: FontFamily.bungee,
    fontWeight: FontWeight.w400,
  );

  late final _leftText = 50.w - (_textSize(nameApp, _styleText).width / 2).wmea;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  );

  late final AnimationController _controllerStarRotate = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 30),
  );

  late final AnimationController _controllerStarScale = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  //* Animation Pict

  late final Animation<RelativeRect> _tween = RelativeRectTween(
    begin: RelativeRect.fromLTRB(0, 0, 0, -5.hmea),
    end: RelativeRect.fromLTRB(0, 0, 0, 12.hmea),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    ),
  );

  //* Animation Text

  late final Animation<RelativeRect> _tweenText = RelativeRectTween(
    begin: RelativeRect.fromLTRB(_leftText, 505.hmea, 0, 0),
    end: RelativeRect.fromLTRB(_leftText, 534.hmea, 0, 0),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    ),
  );

  //* Animation Star Rotate

  late final Animation<double> _animateRotate = Tween<double>(
    begin: 0,
    end: -12.5664,
  ).animate(_controllerStarRotate);

  //* Animation Star Scale

  late final _animateScale = CurvedAnimation(
    parent: _controllerStarScale,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    _controllerStarScale.reset();

    getIt<FToast>().init(MainApp.navKeyGlobal.currentContext!);
    Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (timer.tick == 1) {
          _controller.forward();
        }
        if (timer.tick == 18) {
          _controllerStarScale.forward();
          _controllerStarRotate.forward();
        }

        if (timer.tick == 26) {
          _controllerStarScale.reverse();
        }

        if (timer.tick == 35) {
          timer.cancel();
          context.read<AppBloc>().add(const Redirect());
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PositionedTransition(
          rect: _tweenText,
          child: Text(
            nameApp,
            style: _styleText,
          ),
        ),
        PositionedTransition(
          rect: _tween,
          child: Center(
            child: Assets.lib.resources.images.logo.svg(
              width: 123.wmea,
            ),
          ),
        ),
        Positioned(
          left: 50.w + (_textSize(nameApp, _styleText).width / 2).wmea,
          top: 50.h + 20.wmea,
          child: ScaleTransition(
            scale: _animateScale,
            child: RotationTransition(
              turns: _animateRotate,
              child: Container(
                width: 40.wmea,
                height: 40.wmea,
                decoration: const ShapeDecoration(
                  color: Color(0xFFF2D82D),
                  shape: StarBorder(
                    points: 4,
                    innerRadiusRatio: 0.39,
                    pointRounding: 0,
                    valleyRounding: 0,
                    rotation: 0,
                    squash: 0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerStarRotate.dispose();
    _controllerStarScale.dispose();
    super.dispose();
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
