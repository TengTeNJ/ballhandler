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
  int ? maxLines;
  FontWeight? detailFontWeight;
  CrossAxisAlignment crossAxisAlignment;
  TBTextView({
    required this.title,
    required this.detailTitle,
    this.titleColor = Colors.white,
    this.detailColor = const Color.fromRGBO(177, 177, 177, 1),
    this.titleFontSize = 20,
    this.detailFontSize = 12,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.detailFontWeight,
    this.maxLines
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Constants.customTextBaseColorWidget(title, fontWeight: detailFontWeight, titleFontSize ?? 20, titleColor ?? Colors.white),
        SizedBox(
          height: 6,
        ),
        Constants.customTextBaseColorWidget(detailTitle, fontWeight: detailFontWeight, detailFontSize ?? 12, detailColor ?? Color.fromRGBO(177, 177, 177, 1)),
      ],
    );
  }
}
