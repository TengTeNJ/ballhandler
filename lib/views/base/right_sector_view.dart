import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';
import 'dart:math';
class RightNinetyDegreeSectorPainter extends CustomPainter {
  Color? color;
  RightNinetyDegreeSectorPainter({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color ?? hexStringToOpacityColor('#4A4A4A', 0.72)
      ..style = PaintingStyle.fill;
    // 绘制一个以主视图为参照物的矩形,前两个参数代表是距离主视图的左上角的top left的距离
    final Rect rect = Rect.fromLTWH(0 , 0, size.width   , size.height);
    final double startAngle = 3*pi/2; // 90度的位置
    final double sweepAngle = pi/2; // 扇形的角度
    // 这个是代表绘制圆弧，圆心为主视图的中心
    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}


