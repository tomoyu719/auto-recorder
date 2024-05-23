import 'package:flutter/material.dart';

class FadeTransitionWidget extends StatefulWidget {
  const FadeTransitionWidget({super.key, required this.child});
  final Widget child;

  @override
  State<StatefulWidget> createState() {
    return FadeTransitionState();
  }
}

class FadeTransitionState extends State<FadeTransitionWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000),)
      ..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller.drive(Tween(begin: 0, end: 1)),
      child: widget.child,
    );
  }
}
