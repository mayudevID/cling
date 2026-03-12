import 'package:flutter/material.dart';

class CustomIndexedStack extends StatefulWidget {
  const CustomIndexedStack({
    super.key,
    required this.children,
    required this.index,
    required this.curve,
    this.begin = const Offset(0, 0.02),
    this.end = Offset.zero,
  });

  final List<Widget> children;
  final int? index;
  final Curve? curve;
  final Offset? begin;
  final Offset? end;

  @override
  State<CustomIndexedStack> createState() => _CustomIndexedStackState();
}

class _CustomIndexedStackState extends State<CustomIndexedStack>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomIndexedStack oldWidget) {
    final didIndexChanged = oldWidget.index != widget.index;

    if (didIndexChanged) {
      _controller.reset();
      _controller.forward();

      super.didUpdateWidget(oldWidget);
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: widget.begin,
        end: widget.end,
      )
          .chain(
            CurveTween(curve: widget.curve!),
          )
          .animate(
            _controller,
          ),
      child: IndexedStack(
        index: widget.index,
        children: widget.children,
      ),
    );
  }
}
