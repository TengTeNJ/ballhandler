import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/profile/icon_text_view.dart';
import 'package:flutter/material.dart';

class RewardiconsView extends StatefulWidget {
  List<String> titles = [];
  int currentLevel;

  RewardiconsView({required this.titles, this.currentLevel = 1});

  @override
  State<RewardiconsView> createState() => _RewardiconsViewState();
}

class _RewardiconsViewState extends State<RewardiconsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      height: 100,
      width: Constants.screenWidth(context) - 48,
      decoration: BoxDecoration(
          color: hexStringToColor('#3E3E55'),
          borderRadius: BorderRadius.circular(5)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.titles.length,
        itemBuilder: (BuildContext context, int index) {
          if (index <= widget.currentLevel) {
            return Container(
                child: IconTextView(
                  title: widget.titles[index],
                  iconPath: 'images/profile/dark_blue_icon.png',
                  titleColor: '#FFFFFF',
                ),
                margin: EdgeInsets.only(right: 20));
          } else {
            return Container(
                child: IconTextView(
                  title: widget.titles[index],
                  titleColor: '#B1B1B1',
                ),
                margin: EdgeInsets.only(right: 20));
          }
        },
      ),
    );
  }
}
