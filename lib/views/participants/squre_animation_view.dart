import 'package:flutter/material.dart';

import '../../utils/color.dart';

class SqureAnimationView extends StatefulWidget {
  bool needAnimation;
  Color? color;

  SqureAnimationView({this.needAnimation = false, this.color});

  @override
  State<SqureAnimationView> createState() => _SqureAnimationViewState();
}

class _SqureAnimationViewState extends State<SqureAnimationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return widget.needAnimation
        ? AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                    width: 73,
                    height: 73,
                    color: widget.color ??
                        hexStringToOpacityColor('#4A4A4A', 0.72)),
              );
            })
        : Container(
        width: 73,
        height: 73,
        color: widget.color ??
            hexStringToOpacityColor('#4A4A4A', 0.72));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
