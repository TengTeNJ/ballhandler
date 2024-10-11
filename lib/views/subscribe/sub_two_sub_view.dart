import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

class SubTwoSubView extends StatelessWidget {
  String imageName;
  String desText;

  SubTwoSubView({required this.imageName, required this.desText});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(imageName),
          width: 24,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 14,),
       Container(width: Constants.screenWidth(context) * 0.72 - 24 - 14,child:  Constants.regularWhiteTextWidget(desText, 14,textAlign: TextAlign.start,height: 1.2),),
      ],
    );
  }
}
