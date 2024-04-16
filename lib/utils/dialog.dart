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
/*积分兑换商品弹窗提醒*/
  static integralExchangeDialog(BuildContext context,Function exchange) {
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
            child: ExchangeIntegralDialog(exchange: exchange,),
          ),
        );
      },
    );

  }

  /*积分兑换成功提醒*/
  static integralExchangeSuccessDialog(BuildContext context) {
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
            child: ExchangeIntegralSuccessDialog(),
          ),
        );
      },
    );

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
  }

  static timeSelect(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: hexStringToColor('#3E3E55'),
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        double _height = 0.40;
        return StatefulBuilder(builder: (BuildContext context,StateSetter setState){
          return FractionallySizedBox(
            heightFactor: _height,
            child: TimeSelectDialog(datePickerSelect: (value){
              if(value){
                _height = 0.72;
                setState(() {
                });
              }else{
                _height = 0.40;
                setState(() {
                });
              }
            },),
          );
        });
      },

    );
  }

  static joinAirBattle(BuildContext context,Function continueClick,Function goToSetting) {
    showModalBottomSheet(
      backgroundColor: hexStringToColor('#39394B'),
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.45,
          child: JoinAirBattleDialog(continueClick: continueClick,goToSetting: goToSetting,),
        );
      },
    );
  }

}
