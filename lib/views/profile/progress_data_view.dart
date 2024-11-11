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
      padding: EdgeInsets.only(left: 12,right: 32),
      decoration: BoxDecoration(
          color: hexStringToColor('#3E3E55'),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.translate(child:  Constants.regularWhiteTextWidget('Your  Rewards Progress', 16,height: 0.8), offset: Offset(0.0,6.0)),
          Container(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: Constants.screenWidth(context) * 0.56,height: 6,child: LinearProgressIndicator(
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(10),
                    value: widget.model.integral/widget.model.upperLimit,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Constants.baseStyleColor),
                  ),),
                  Image(image: AssetImage('images/profile/progress_${widget.model.memberLevel}.png'),width: 46,height: 50,)
                ],
              ),
              Transform.translate(child:  Row(
                children: [
                  Text(widget.model.integral.toString(),style: TextStyle(color: Constants.baseStyleColor,fontSize: 14,height: 0.8),),
                  Text('/' + widget.model.upperLimit.toString(), style: TextStyle(color: Colors.white,fontSize: 14,height: 0.8),),
                ],
              ),  offset: Offset(0.0, -6.0),
              ),
            ],
          ),),
        ],
      ),
    );
  }
}
