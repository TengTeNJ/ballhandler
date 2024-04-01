import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/profile/icon_text_view.dart';
import 'package:flutter/material.dart';

class RewardiconsView extends StatefulWidget {
  const RewardiconsView({super.key});

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
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: IconTextView(title: 'qwertyuio'),
            margin: EdgeInsets.only(right: 20)
          );
        },
      ),
    );
  }
}
