import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils.dart';
import '../../../resources/gen/assets.gen.dart';
import 'animation_onboard.dart';

class EmoticonWidget extends StatefulWidget {
  const EmoticonWidget({super.key});

  @override
  State<EmoticonWidget> createState() => _EmoticonWidgetState();
}

class _EmoticonWidgetState extends State<EmoticonWidget>
    with TickerProviderStateMixin {
  late Animation<RelativeRect> _animationTween;
  @override
  void initState() {
    _animationTween = AnimationOnboard.setAnimationEmoticon(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: _animationTween,
      child: Center(
        child: Assets.lib.resources.images.emoticon.image(
          width: Utils.w(230).w,
          height: Utils.w(230).w,
        ),
      ),
    );
  }
}
