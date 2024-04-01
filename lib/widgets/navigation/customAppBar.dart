import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String? title;
  bool? showBack;

  CustomAppBar({this.title = '', this.showBack = false,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:  showBack == true ?  GestureDetector(
        onTap: (){
          NavigatorUtil.pop();
        },
        child: Container(
          padding: EdgeInsets.all(10), // 可选的，根据需要设置内边距
          child: Image.asset('images/base/back.png'), // 替换为您的图片路径
        ),
      ):null,
      // ),
      title: Text(title.toString(),style: TextStyle(color: Colors.white),),
      backgroundColor: Constants.darkThemeColor,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(44);
}
