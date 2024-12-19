import 'dart:async';
import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: BlinkingContainer()));
}

class BlinkingContainer extends StatefulWidget {
  @override
  _BlinkingContainerState createState() => _BlinkingContainerState();
}

class _BlinkingContainerState extends State<BlinkingContainer> {
  double _opacity = 1.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _opacity = _opacity == 1.0 ? 0.0 : 1.0;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(
          milliseconds: 3), // Adjust the speed of the blinking effect here
      child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              goldenColor,
              goldenColor2
            ], // Assuming goldenColor and goldenColor2 are defined
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
