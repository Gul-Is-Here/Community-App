import 'dart:async';

import 'package:flutter/material.dart';

class BlinkingDot extends StatefulWidget {
  @override
  _BlinkingDotState createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<BlinkingDot>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _isVisible = !_isVisible;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      width: 10,
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: Color(0xFF6CFD74),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
