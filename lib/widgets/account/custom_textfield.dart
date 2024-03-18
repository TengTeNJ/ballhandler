import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class CustomTextField extends StatefulWidget {
  TextEditingController? controller;
  String ?placeHolder;
  TextInputType? keyboardType;
  final void Function()? onTap;
  bool? obscureText = false;

  CustomTextField({ this.controller,this.placeHolder = '',this.keyboardType,this.onTap,this.obscureText });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obscureText ?? false,
      onTap: widget.onTap,
      keyboardType: widget.keyboardType != null ? widget.keyboardType : TextInputType.emailAddress,
      style: TextStyle(color: Constants.baseStyleColor),
      // 设置字体颜色
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(28, 30, 33, 1.0),
        hintText:widget.placeHolder,
        // 占位符文本
        hintStyle: Constants.placeHolderStyle(),
        // 占位符颜色
        border: OutlineInputBorder(
            borderSide: BorderSide.none, // 移除边框
            borderRadius: BorderRadius.circular(10)), // 输入框边框样式
      ) /**/,
    );
  }
}
