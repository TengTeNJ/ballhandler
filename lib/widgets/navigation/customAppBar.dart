import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String? title;

  CustomAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title.toString()),
      backgroundColor: Constants.darkThemeColor,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(44);
}
