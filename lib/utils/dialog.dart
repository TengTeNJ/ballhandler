import 'package:code/utils/color.dart';
import 'package:code/views/dialog/dialog.dart';
import 'package:flutter/material.dart';

class TTDialog {
  /**发送邮件**/
  static sendEmailDialog(BuildContext context) {
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
  static bleListDialog(BuildContext context) {
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

  static integralExchangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: hexStringToColor('#3E3E55'),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ExchangeIntegralDialog(),
          ),
        );
      },
    );

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Dialog(
    //         backgroundColor: Colors.transparent,
    //         child: ExchangeIntegralDialog(),);
    //     });
  }

  static championDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: hexStringToColor('#3E3E55'),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ChampionDialog(),
          ),
        );
      },
    );

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Dialog(
    //         backgroundColor: Colors.transparent,
    //         child: ExchangeIntegralDialog(),);
    //     });
  }

  static awardDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: hexStringToColor('#39394B'),
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.42,
          child: AwardDialog(),
        );
      },
    );

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Dialog(
    //         backgroundColor: Colors.transparent,
    //         child: ExchangeIntegralDialog(),);
    //     });
  }

}
