import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';

import '../../../../resources/gen/assets.gen.dart';

class EmoticonWidget extends StatefulWidget {
  const EmoticonWidget({super.key});

  @override
  State<EmoticonWidget> createState() => _EmoticonWidgetState();
}

class _EmoticonWidgetState extends State<EmoticonWidget>
    with TickerProviderStateMixin {
  late Image imageEmot;
  late AnimationController animation;
  late Animation<RelativeRect> animationTween;

  @override
  void initState() {
    imageEmot = Assets.lib.resources.imagesPng.emoticon.image(
      width: 230.wmea,
      height: 230.wmea,
    );

    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animationTween = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0, 0, 0, -1 * 55.hmea),
      end: RelativeRect.fromLTRB(0, 0, 0, 55.hmea),
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
    );

    animation.forward();
    animationTween.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          animation.reverse();
          Future.delayed(const Duration(seconds: 2)).then(
            (value) {
              animation.forward();
            },
          );
        }
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(imageEmot.image, context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: animationTween,
      child: Center(
        child: imageEmot,
      ),
    );
  }
}
