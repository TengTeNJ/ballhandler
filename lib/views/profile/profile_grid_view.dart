import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:widget_tooltip/widget_tooltip.dart';

class ProfileGridView extends StatefulWidget {
  String? assetPath;
  String? title;
  String? unit;
  String? des;

  ProfileGridView({this.assetPath, this.title, this.unit, this.des});

  @override
  State<ProfileGridView> createState() => _ProfileGridViewState();
}

class _ProfileGridViewState extends State<ProfileGridView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      width: (Constants.screenWidth(context) - 56) / 2.0,
      decoration: BoxDecoration(
          color: hexStringToColor('#3E3E55'),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 18, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image(
                  image: AssetImage(
                      widget.assetPath ?? 'images/profile/time.png' ''),
                  width: 28,
                  height: 22,
                )
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxWidth:
                              (Constants.screenWidth(context) - 56) / 2.0 - 44),
                      child: widget.title != null && widget.title!.length > 4
                          ? WidgetTooltip(
                              triggerMode: WidgetTooltipTriggerMode.tap,
                              message: Constants.boldWhiteTextWidget(
                                  widget.title ?? '--', 30, height: 0.8),
                              child: Constants.boldWhiteTextWidget(
                                  widget.title ?? '--', 40, height: 0.8))
                          : Constants.boldWhiteTextWidget(
                              widget.title ?? '--', 40,
                              height: 0.8),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Constants.regularWhiteTextWidget(widget.unit ?? 'Sec', 10,
                        height: 0.8)
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Constants.regularGreyTextWidget(
                    widget.des ?? 'Best React Time', 14)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
