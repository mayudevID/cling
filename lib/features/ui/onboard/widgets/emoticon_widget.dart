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
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: AnimationOnboard.setAnimationEmoticon(this),
      child: Center(
        child: Assets.lib.resources.images.emoticon.image(
          width: 230.wmea,
          height: 230.wmea,
        ),
      ),
    );
  }
}
