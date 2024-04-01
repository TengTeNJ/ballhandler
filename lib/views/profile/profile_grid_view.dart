import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';
class ProfileGridView extends StatefulWidget {
  const ProfileGridView({super.key});

  @override
  State<ProfileGridView> createState() => _ProfileGridViewState();
}

class _ProfileGridViewState extends State<ProfileGridView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      width: (Constants.screenWidth(context) - 56 )/ 2.0,
      decoration: BoxDecoration(color: hexStringToColor('#3E3E55'),borderRadius: BorderRadius.circular(5)),
    );
  }
}
