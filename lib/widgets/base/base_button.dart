import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

import '../../utils/color.dart';

class BaseButton extends StatelessWidget {
  String title;
  Function? onTap;
  double height;
  LinearGradient? linearGradient;

  BaseButton({required this.title, this.height = 44,this.onTap,this.linearGradient});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: (){
      if(onTap!=null){
        onTap!();
      }

    },child: Container(
      height: height,
      decoration: BoxDecoration(
          gradient:  linearGradient,
          borderRadius: BorderRadius.circular(10),
          color: Constants.baseStyleColor,),
      child: Center(
        child: Constants.regularWhiteTextWidget(title, 16),
      ),
    ),);
  }
}
