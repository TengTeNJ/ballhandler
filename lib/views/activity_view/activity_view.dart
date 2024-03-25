import 'package:code/constants/constants.dart';
import 'package:code/models/airbattle/activity_model.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityView extends StatefulWidget {
  ActivityModel activityModel;

  ActivityView({required this.activityModel});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) - 32,
      height: 180,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('images/airbattle/under_way.png'),
        fit: BoxFit.fill,
      )),
      child: Stack(
        children: [
          Positioned(
              top: 8,
              right: 12,
              child: Container(
                width: 100,
                height: 26,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image(
                      image: AssetImage('images/airbattle/trophy.png'),
                      width: 12,
                      height: 10,
                    ),
                    Constants.regularWhiteTextWidget('Under Way', 14,
                        height: 1.0),
                  ],
                ),
                decoration: BoxDecoration(
                    color: hexStringToOpacityColor('#1C1E21', 0.6),
                    borderRadius: BorderRadius.circular(5)),
              )),
          Positioned(
            top: 28,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('images/airbattle/icon.png'),
                  width: 58,
                  height: 58,
                ),
                Constants.boldWhiteTextWidget(widget.activityModel.title, 20),
                SizedBox(height: 6,),
                Constants.regularWhiteTextWidget(widget.activityModel.des, 14),

              ],
            ),
          ),
          Positioned(
              bottom: 12,
              left: 32,
              right: 32,
              child: Constants.regularWhiteTextWidget('JULY.2024', 10)),
        ],
      ),
    );
  }
}
