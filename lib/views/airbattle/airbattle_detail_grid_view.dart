import 'package:code/utils/color.dart';
import 'package:code/widgets/base/top_bottom_text_view.dart';
import 'package:flutter/material.dart';

class AirBattleGridView extends StatelessWidget {
  String imagePath;
  String title;
  String detail;

  AirBattleGridView(
      {required this.imagePath, required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: hexStringToColor('#3E3E55'),
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Image(
              image: AssetImage(imagePath),
              width: 18,
              height: 18,
            ),
          ),
        ),
        SizedBox(width: 4,),
        Expanded(child: TBTextView(title: title, detailTitle: detail)),
      ],
    );
  }
}
