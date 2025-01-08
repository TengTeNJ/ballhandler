import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class RazorProgressView extends StatefulWidget {
  bool onGoing;
  double size;
  int count;
  int currentIndex;

  RazorProgressView(
      {super.key,
      required this.count,
      this.size = 10,
      this.currentIndex = 0,
      this.onGoing = false});

  @override
  State<RazorProgressView> createState() => _RazorProgressViewState();
}

class _RazorProgressViewState extends State<RazorProgressView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      child: ListView.separated(
          shrinkWrap: true,
          // 让ListView的大小根据内容来决定
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            Color color = hexStringToColor('#14B2B8');
            if(widget.onGoing){
              if (index == widget.currentIndex) {
                color = Constants.baseStyleColor;
              } else if (index < widget.currentIndex) {
                color = Constants.baseGreyStyleColor;
              }
            }
            return Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(widget.size / 2.0)),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 12,
            );
          },
          itemCount: widget.count),
    );
  }
}
