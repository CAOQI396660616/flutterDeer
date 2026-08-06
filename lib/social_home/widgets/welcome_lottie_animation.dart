// ignore_for_file: always_put_control_body_on_new_line

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeLottieAnimation extends StatefulWidget {
  const WelcomeLottieAnimation({super.key, required this.onCompleted});

  final VoidCallback onCompleted;

  @override
  State<WelcomeLottieAnimation> createState() => _WelcomeLottieAnimationState();
}

class _WelcomeLottieAnimationState extends State<WelcomeLottieAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) widget.onCompleted();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Lottie.asset(
        'assets/lottie/login.json',
        controller: _controller,
        repeat: false,
        onLoaded: (LottieComposition composition) {
          _controller
            ..duration = composition.duration
            ..forward();
        },
      );
}
