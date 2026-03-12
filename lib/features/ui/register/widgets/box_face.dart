import 'dart:async';

import '../../../../resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class BoxFace extends StatelessWidget {
  const BoxFace({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 324.04,
        height: 152,
        decoration: const BoxDecoration(
          color: Color(0xFF07AC65),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 31.74,
            ),
            const EyeWidget(),
            const SizedBox(
              height: 8.35,
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
                width: 33.41,
                height: 33.41,
                child: Stack(
                  children: [
                    Container(
                      width: 33.41,
                      height: 33.41,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: OvalBorder(),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 20.04,
                        height: 20.04,
                        decoration: const ShapeDecoration(
                          color: Colors.black,
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8.35,
              ),
              SizedBox(
                width: 33.41,
                height: 33.41,
                child: Stack(
                  children: [
                    Container(
                      width: 33.41,
                      height: 33.41,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: OvalBorder(),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 20.04,
                        height: 20.04,
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
                width: 33.41,
                height: 33.41,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 5,
                  ),
                  width: 33.41,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(
                width: 8.35,
              ),
              SizedBox(
                width: 33.41,
                height: 33.41,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 5,
                  ),
                  width: 33.41,
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
