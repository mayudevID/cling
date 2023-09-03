import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';

import '../../../../resources/gen/assets.gen.dart';

import 'animation_onboard.dart';

class EmoticonWidget extends StatefulWidget {
  const EmoticonWidget({super.key});

  @override
  State<EmoticonWidget> createState() => _EmoticonWidgetState();
}

class _EmoticonWidgetState extends State<EmoticonWidget>
    with TickerProviderStateMixin {
  late Image imageEmot;

  @override
  void initState() {
    imageEmot = Assets.lib.resources.imagesPng.emoticon.image(
      width: 230.wmea,
      height: 230.wmea,
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
    AnimationOnboard.animC4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: AnimationOnboard.setAnimationEmoticon(this),
      child: Center(
        child: imageEmot,
      ),
    );
  }
}
