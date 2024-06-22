import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String? title;
  bool? showBack;
  Color? customBackgroundColor;
  CustomAppBar({this.title = '', this.showBack = false,this.customBackgroundColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading:  showBack == true ?  GestureDetector(
        onTap: (){
          NavigatorUtil.pop();
        },
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 点击返回按钮时的操作
            Navigator.of(context).pop();
          },
          color: Colors.white,
          iconSize: 30, // 设置图标大小
        ),
      ):null,
      // ),
      title: Text(title.toString(),style: TextStyle(color: Colors.white),),
      backgroundColor: customBackgroundColor ??  Constants.darkThemeColor,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(44);
}
