import 'package:code/views/dialog/dialog.dart';
import 'package:flutter/material.dart';

class TTDialog {
  static sendEmailDialog(BuildContext context){
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
           heightFactor: 0.42,
          child: SendEmailDiaog(),
        );
      },
    );
  }
}