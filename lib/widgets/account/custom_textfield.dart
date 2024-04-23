import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../constants/constants.dart';

class CustomTextField extends StatefulWidget {
  TextStyle ? hintStyle;
  TextEditingController controller;
  String ?placeHolder;
  TextInputType? keyboardType;
  final void Function(String text)? onTap;
  bool? obscureText = false;

  CustomTextField({ required this.controller,this.placeHolder = '',this.keyboardType,this.onTap,this.obscureText,this.hintStyle });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller!.addListener(() {
      if(widget.onTap != null){
        widget.onTap!(widget.controller!.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obscureText ?? false,
      keyboardType: widget.keyboardType != null ? widget.keyboardType : TextInputType.emailAddress,
      style: TextStyle(color: Constants.baseStyleColor),
      // 设置字体颜色
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(28, 30, 33, 1.0),
        hintText:widget.placeHolder,
        // 占位符文本
        hintStyle: widget.hintStyle == null ? Constants.placeHolderStyle() : widget.hintStyle,
        // 占位符颜色
        border: OutlineInputBorder(
            borderSide: BorderSide.none, // 移除边框
            borderRadius: BorderRadius.circular(10)), // 输入框边框样式
      ) /**/,
    );
  }
}
