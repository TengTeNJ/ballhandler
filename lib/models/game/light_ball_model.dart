import 'dart:ui';

class LightBallModel{
  double? left;
  double? bottom;
  double? right;
  double? top;
  Color color;
  bool show;
  LightBallModel({required this.color,this.show = false,this.left,this.right,this.top,this.bottom});
}