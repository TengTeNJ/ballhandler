import 'package:code/constants/constants.dart';
import 'package:code/services/http/profile.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressDataView extends StatefulWidget {
  MyAccountDataModel model;
   ProgressDataView({required this.model});

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
                    value: widget.model.integral/widget.model.upperLimit,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Constants.baseStyleColor),
                  ),),
                  Image(image: AssetImage('images/profile/progress_${widget.model.memberLevel}.png'),width: 37,height: 42,)
                ],
              ),
             Transform.translate(child:  Row(
               children: [
                 Text(widget.model.integral.toString(),style: TextStyle(color: Constants.baseStyleColor,fontSize: 14,height: 1.0),),
                 Text('/' + widget.model.upperLimit.toString(), style: TextStyle(color: Colors.white,fontSize: 14,height: 1.0),),
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
