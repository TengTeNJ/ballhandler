import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class TBTextView extends StatelessWidget {
  String title;
  String detailTitle;
  Color? titleColor;
  Color? detailColor;
  double? titleFontSize;
  double? detailFontSize;

  TBTextView({
    required this.title,
    required this.detailTitle,
    this.titleColor = Colors.white,
    this.detailColor = const Color.fromRGBO(177, 177, 177, 1),
    this.titleFontSize = 20,
    this.detailFontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
              color: titleColor,
              fontFamily: 'SanFranciscoDisplay',
              fontSize: titleFontSize,
              height: 1.0),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          detailTitle,
          style: TextStyle(
              color: detailColor,
              fontFamily: 'SanFranciscoDisplay',
              fontSize: detailFontSize,
              height: 1.0),
        ),
      ],
    );
  }
}
