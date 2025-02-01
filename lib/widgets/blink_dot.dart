import 'dart:async';
import 'package:flutter/material.dart';

class BlinkingDot extends StatefulWidget {
  const BlinkingDot({Key? key}) : super(key: key);

  @override
  _BlinkingDotState createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<BlinkingDot>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startBlinking() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _isVisible = !_isVisible);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: const Color(0xFF6CFD74),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
