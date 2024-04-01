import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressDataView extends StatefulWidget {
  const ProgressDataView({super.key});

  @override
  State<ProgressDataView> createState() => _ProgressDataViewState();
}

class _ProgressDataViewState extends State<ProgressDataView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 91,
      padding: EdgeInsets.only(left: 12,right: 12),
      decoration: BoxDecoration(
          color: hexStringToColor('#3E3E55'),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Constants.regularWhiteTextWidget('Your  Progress', 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 200,height: 6,child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(10),
                    value: 0.8,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Constants.baseStyleColor),
                  ),),
                  Image(image: AssetImage('images/profile/gold.png'),width: 37,height: 42,)
                ],
              ),
             Transform.translate(child:  Row(
               children: [
                 Text('800',style: TextStyle(color: Constants.baseStyleColor,fontSize: 14,height: 1.0),),
                 Text('/100',style: TextStyle(color: Colors.white,fontSize: 14,height: 1.0),),
               ],
             ),  offset: Offset(0.0, -10.0),
             ),
            ],
          )
        ],
      ),
    );
  }
}
