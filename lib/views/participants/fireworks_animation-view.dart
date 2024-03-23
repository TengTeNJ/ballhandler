import 'package:flutter/material.dart';

class ImageAnimation extends StatefulWidget {
  @override
  _ImageAnimationState createState() => _ImageAnimationState();
}

class _ImageAnimationState extends State<ImageAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        // if (status == AnimationStatus.completed) {
        //   _controller.reverse();
        // } else if (status == AnimationStatus.dismissed) {
        //   _controller.forward();
        // }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: _animation.value,
        child: Opacity(
          opacity: 1 - (_animation.value - 1).abs(),
          child: Image.asset('images/participants/fireworks.png'), // Replace 'your_image.png' with your image path
        ),
      ),
    );
  }
}
