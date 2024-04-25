import 'package:flutter/material.dart';

class DownArrowAnimationWidget extends StatefulWidget {
  @override
  _DownArrowAnimationWidgetState createState() =>
      _DownArrowAnimationWidgetState();
}

class _DownArrowAnimationWidgetState extends State<DownArrowAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform.translate(
                  offset: Offset(0, 5 * _controller.value),
                  child: child,
                );
              },
              child: Icon(Icons.keyboard_double_arrow_down)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
