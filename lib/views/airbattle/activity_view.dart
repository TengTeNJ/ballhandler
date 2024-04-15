import 'package:code/constants/constants.dart';
import 'package:code/services/http/airbattle.dart';
import 'package:code/utils/color.dart';
import 'package:code/widgets/base/base_image.dart';
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
      decoration: BoxDecoration(),
      child: Stack(
        children: [
          TTNetImage(
              url: widget.activityModel.activityBackground,
              placeHolderPath: 'images/airbattle/under_way.png',
              width: Constants.screenWidth(context) - 32,
              height: 180,
              borderRadius: BorderRadius.circular(10)),
          Positioned(
              top: 8,
              right: 12,
              child: Container(
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image(
                      image: AssetImage('images/airbattle/trophy.png'),
                      width: 12,
                      height: 10,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Constants.regularWhiteTextWidget(
                        widget.activityModel.statuString, 14,
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
                TTNetImage(
                  url: widget.activityModel.activityIcon,
                  placeHolderPath: 'images/airbattle/icon.png',
                  width: 58,
                  height: 58,
                ),
                // Image(
                //   image: AssetImage('images/airbattle/icon.png'),
                //   width: 58,
                //   height: 58,
                // ),
                SizedBox(
                  height: 6,
                ),
                Constants.boldWhiteTextWidget(
                    widget.activityModel.activityName, 20),
                SizedBox(
                  height: 6,
                ),
                Constants.regularWhiteTextWidget(
                    widget.activityModel.activityRemark, 14),
              ],
            ),
          ),
          Positioned(
              bottom: 12,
              left: 32,
              right: 32,
              child: Constants.regularWhiteTextWidget(
                  widget.activityModel.startDate +
                      '-' +
                      widget.activityModel.endDate,
                  10)),
        ],
      ),
    );
  }
}
