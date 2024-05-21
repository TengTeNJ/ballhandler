import 'package:code/utils/color.dart';
import 'package:code/views/dialog/dialog.dart';
import 'package:flutter/material.dart';

class TTDialog {
  /**发送邮件**/
  static sendEmailDialog(BuildContext context,Function confirm) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.42,
          child: SendEmailDiaog(confirm: confirm,),
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

  static championDialog(BuildContext context,Function gotIt) {
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
            child: ChampionDialog(gotIt: gotIt,),
          ),
        );
      },
    );
  }

  static awardDialog(BuildContext context,Function gotIt) {
    showModalBottomSheet(
      backgroundColor: hexStringToColor('#39394B'),
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.42,
          child: AwardDialog(gotIt: gotIt,),
        );
      },
    );
  }

  static timeSelect(BuildContext context,Function confirm,{int index = 0,String? start,String? end}) {
    showModalBottomSheet(
      backgroundColor: hexStringToColor('#3E3E55'),
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        double _height = 0.5;
        return StatefulBuilder(builder: (BuildContext context,StateSetter setState){
          return FractionallySizedBox(
            heightFactor: _height,
            child: TimeSelectDialog( startTime: start, endTime: end, selectIndex: index, datePickerSelect: (value){
              if(value){
                _height = 0.80;
                setState(() {
                });
              }else{
                _height = 0.5;
                setState(() {
                });
              }
            },confirm: (startTime,endTime,selectIndex){
              if(confirm!=null){
                int _index = selectIndex;
                if(selectIndex == -1){
                  _index = 3;
                }
                confirm(startTime,endTime,_index);
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

  static userNameDialog(BuildContext context,Function confirm){
    return showDialog(context: context, builder: (context){
      return UserNameDialog(confirm: confirm,);
    });
  }


  static airplayDialog(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AirPlayView();
    });
  }

  /* 视频引导页*/
  static videiGuideAidlog(BuildContext context,String videoPath){

    showModalBottomSheet(
      // backgroundColor: Colors.transparent,
      backgroundColor: hexStringToColor('#3E3E55'),
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.95,
          child: VideoGuideDialog(videoPath: videoPath),
        );
      },
    );
  }
}
