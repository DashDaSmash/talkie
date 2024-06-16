import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

import 'package:talkie/SpeechScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF040307), Color(0xFF310076)],
            ),
          ),
          child: Center(
            child: ResizeCubeAnimation(),
          ),
        ),
      ),
    );
  }
}

class ResizeCubeAnimation extends StatelessWidget {
  const ResizeCubeAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PlayAnimationBuilder plays animation once
    return PlayAnimationBuilder<double>(
      tween: Tween(begin: 130.0, end: 150.0), // 100.0 to 200.0
      duration: const Duration(seconds: 1), // for 1 second
      builder: (context, value, _) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SpeechScreen()),
            );
          },
          child: CircleAvatar(
            radius: value,
            backgroundImage: AssetImage('images/appIcon.jpg'),
          ),
        );
      },
      onCompleted: () {
        // do something ...
      },
    );
  }
}
