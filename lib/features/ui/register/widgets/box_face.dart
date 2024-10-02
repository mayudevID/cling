import 'dart:async';

import 'package:cling/resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BoxFace extends StatelessWidget {
  const BoxFace({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 324.04.w,
        height: 152.h,
        decoration: const BoxDecoration(
          color: Color(0xFF07AC65),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 31.74.h,
            ),
            const EyeWidget(),
            SizedBox(
              height: 8.35.w,
            ),
            Assets.lib.resources.images.smile.svg(),
          ],
        ),
      ),
    );
  }
}

class EyeWidget extends StatefulWidget {
  const EyeWidget({super.key});

  @override
  State<EyeWidget> createState() => _EyeWidgetState();
}

class _EyeWidgetState extends State<EyeWidget> {
  bool isBlinking = false;

  @override
  void initState() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));

      for (var i = 0; i < 3; i++) {
        if (!mounted) {
          break;
        }
        setState(() {
          isBlinking = !isBlinking;
        });

        await Future.delayed(const Duration(milliseconds: 150));
      }

      if (!mounted) {
        return mounted;
      }
      setState(() {
        isBlinking = !isBlinking;
      });

      return mounted;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (!isBlinking)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 33.41.w,
                height: 33.41.w,
                child: Stack(
                  children: [
                    Container(
                      width: 33.41.w,
                      height: 33.41.w,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: OvalBorder(),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 20.04.w,
                        height: 20.04.w,
                        decoration: const ShapeDecoration(
                          color: Colors.black,
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 8.35.w,
              ),
              SizedBox(
                width: 33.41.w,
                height: 33.41.w,
                child: Stack(
                  children: [
                    Container(
                      width: 33.41.w,
                      height: 33.41.w,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: OvalBorder(),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 20.04.w,
                        height: 20.04.w,
                        decoration: const ShapeDecoration(
                          color: Colors.black,
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 33.41.w,
                height: 33.41.w,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 15.h,
                    horizontal: 5.w,
                  ),
                  width: 33.41.w,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(
                width: 8.35.w,
              ),
              SizedBox(
                width: 33.41.w,
                height: 33.41.w,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 15.h,
                    horizontal: 5.w,
                  ),
                  width: 33.41.w,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          );
  }
}
