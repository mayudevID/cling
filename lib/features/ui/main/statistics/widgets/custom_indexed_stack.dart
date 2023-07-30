import 'package:flutter/material.dart';

class CustomIndexedStack extends StatefulWidget {
  const CustomIndexedStack({
    super.key,
    required this.children,
    required this.index,
  });

  final List<Widget> children;
  final int? index;

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
      duration: const Duration(milliseconds: 500),
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
        begin: const Offset(0, 0.02),
        end: const Offset(0, 0),
      )
          .chain(
            CurveTween(curve: Curves.easeOutExpo),
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
