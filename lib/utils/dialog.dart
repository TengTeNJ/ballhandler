import 'package:code/views/dialog/dialog.dart';
import 'package:flutter/material.dart';

class TTDialog {
  /**发送邮件**/
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
  /**蓝牙列表**/
  static bleListDialog(BuildContext context){
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.42,
          child: BLEListDialog(),
        );
      },
    );
  }

}