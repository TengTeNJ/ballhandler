import 'package:code/views/base/right_sector_view.dart';
import 'package:flutter/material.dart';

import '../base/sector_view.dart';
class SectorAnimationView extends StatefulWidget {
   bool isLeft;
   Color? color;
   bool needAnimation;
   SectorAnimationView({this.isLeft = true,this.color,this.needAnimation = false});

  @override
  State<SectorAnimationView> createState() => _SectorAnimationViewState();
}

class _SectorAnimationViewState extends State<SectorAnimationView>  with SingleTickerProviderStateMixin{
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
    return widget.needAnimation ?  AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              child: CustomPaint(
                  painter: NinetyDegreeSectorPainter(isLeft: widget.isLeft,color: widget.color)
              ),
            ),
          );
        }) : Container(
      child: CustomPaint(
          painter: NinetyDegreeSectorPainter(isLeft: widget.isLeft,color: widget.color)
      ),
    );
  }
}
