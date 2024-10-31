import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class IntegralShowView extends StatefulWidget {
  int userIntegral = 0; // 用户的积分
  int integralMinLevel = 2000;
  int integralMaxLevel = 5000;
  Function? onTap;

  IntegralShowView(
      {this.userIntegral = 0,
      this.integralMinLevel = 2000,
      this.integralMaxLevel = 5000,this.onTap});

  @override
  State<IntegralShowView> createState() => _IntegralShowViewState();
}

class _IntegralShowViewState extends State<IntegralShowView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: (){
         if(widget.userIntegral >= widget.integralMinLevel){
           if(widget.onTap != null){
             widget.onTap!();
           }
         }
       },
      behavior: HitTestBehavior.opaque,
       child: Container(
         decoration: BoxDecoration(
             color: Constants.baseControllerColor,
             borderRadius: BorderRadius.circular(9)),
         width: 121,
         height: 161,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Constants.regularBaseTextWidget(
                 widget.integralMinLevel.toString() + ' Pucks', 14),
             SizedBox(
               height: 20,
             ),
             Image(
               image: AssetImage('images/profile/lock.png'),
               height: 50,
             ),
             SizedBox(
               height: 20,
             ),
             Container(
               width: 74,
               height: 20,
               decoration: BoxDecoration(
                   color: widget.userIntegral >= widget.integralMinLevel
                       ? Constants.baseStyleColor
                       : hexStringToColor('#3A3A51'),
                   borderRadius: BorderRadius.circular(10)),
               child: Center(
                 child: widget.userIntegral >= widget.integralMinLevel
                     ? Constants.regularWhiteTextWidget(
                     'UNLOCK', 12)
                     : Constants.regularGreyTextWidget(
                     'LOCKED', 12),
               ),
             )
           ],
         ),
       ),
    );
  }
}
