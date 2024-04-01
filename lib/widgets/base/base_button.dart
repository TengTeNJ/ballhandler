import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  String title;
  Function? onTap;
  double height;

  BaseButton({required this.title, this.height = 44,this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: (){
      onTap??();
    },child: Container(
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Constants.baseStyleColor),
      child: Center(
        child: Constants.regularWhiteTextWidget(title, 16),
      ),
    ),);
  }
}
