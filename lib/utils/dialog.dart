import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/dialog/dialog.dart';
import 'package:flutter/material.dart';

class TTDialog {
  /**发送邮件**/
  static sendEmailDialog(BuildContext context, Function confirm) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.42,
          child: SendEmailDiaog(
            confirm: confirm,
          ),
        );
      },
    );
  }

  static sendIpadEmailDialog(BuildContext context, Function confirm) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.42,
          child: IpadSendEmailDiaog(
            confirm: confirm,
          ),
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
          heightFactor: 0.5,
          child: BLEListDialog(),
        );
      },
    );
  }

  static ipadbleListDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.42,
          child: IpadBLEListDialog(),
        );
      },
    );
  }

/*积分兑换商品弹窗提醒*/
  static integralExchangeDialog(BuildContext context, Function exchange) {
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
            child: ExchangeIntegralDialog(
              exchange: exchange,
            ),
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

  static championDialog(BuildContext context, Function gotIt) {
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
            child: ChampionDialog(
              gotIt: gotIt,
            ),
          ),
        );
      },
    );
  }

  static awardDialog(BuildContext context, Function gotIt) {
    showModalBottomSheet(
      backgroundColor: hexStringToColor('#39394B'),
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.42,
          child: AwardDialog(
            gotIt: gotIt,
          ),
        );
      },
    );
  }

  static timeSelect(BuildContext context, Function confirm,
      {int index = 0, String? start, String? end}) {
    showModalBottomSheet(
      backgroundColor: hexStringToColor('#3E3E55'),
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        double _height = 0.5;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return FractionallySizedBox(
            heightFactor: _height,
            child: TimeSelectDialog(
              startTime: start,
              endTime: end,
              selectIndex: index,
              datePickerSelect: (value) {
                if (value) {
                  _height = 0.80;
                  setState(() {});
                } else {
                  _height = 0.5;
                  setState(() {});
                }
              },
              confirm: (startTime, endTime, selectIndex) {
                if (confirm != null) {
                  int _index = selectIndex;
                  if (selectIndex == -1) {
                    _index = 3;
                  }
                  confirm(startTime, endTime, _index);
                }
              },
            ),
          );
        });
      },
    );
  }

  static iPadTimeSelect(BuildContext context, Function confirm,
      {int index = 0, String? start, String? end}) {
    showModalBottomSheet(
      backgroundColor: hexStringToColor('#3E3E55'),
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        double _height = 0.5;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return FractionallySizedBox(
            heightFactor: _height,
            child: IpadTimeSelectDialog(
              startTime: start,
              endTime: end,
              selectIndex: index,
              datePickerSelect: (value) {
                if (value) {
                  _height = 0.80;
                  setState(() {});
                } else {
                  _height = 0.5;
                  setState(() {});
                }
              },
              confirm: (startTime, endTime, selectIndex) {
                if (confirm != null) {
                  int _index = selectIndex;
                  if (selectIndex == -1) {
                    _index = 3;
                  }
                  confirm(startTime, endTime, _index);
                }
              },
            ),
          );
        });
      },
    );
  }

  static joinAirBattle(
      BuildContext context, Function continueClick, Function goToSetting) {
    showModalBottomSheet(
      backgroundColor: hexStringToColor('#39394B'),
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.45,
          child: JoinAirBattleDialog(
            continueClick: continueClick,
            goToSetting: goToSetting,
          ),
        );
      },
    );
  }

  static userNameDialog(BuildContext context, Function confirm) {
    return showDialog(
        context: context,
        builder: (context) {
          return UserNameDialog(
            confirm: confirm,
          );
        });
  }

  static channelDialog(BuildContext context, Function confirm) {
    return showDialog(
        context: context,
        builder: (context) {
          return ChannelDialog(
            confirm: confirm,
          );
        });
  }

  static setRemainTimeDialog(BuildContext context, Function confirm) {
    return showDialog(
        context: context,
        builder: (context) {
          return RemainTimeDialog(
            confirm: confirm,
          );
        });
  }

  static setInterferenceLevelDialog(BuildContext context, Function confirm) {
    return showDialog(
        context: context,
        builder: (context) {
          return InterferenceLevelDialog(
            confirm: confirm,
          );
        });
  }

  static airplayDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AirPlayView();
        });
  }

  /* 视频引导页*/
  static videiGuideAidlog(BuildContext context, String videoPath) {
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

  /**订阅弹窗列表**/
  static subscribeDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: hexStringToColor('#3E3E55'),
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.81,
          child: SubscribeDialog(),
        );
      },
    );
  }

  /**投屏提醒弹窗**/
  static mirrorScreenDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Constants.darkControllerColor,
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.45,
          child: MirrorScreenDialog(),
        );
      },
    );
  }

  /**横屏投屏提醒弹窗**/
  static horizontalMirrorScreenDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Constants.darkControllerColor,
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.70,
          child: MirrorScreenDialog(),
        );
      },
    );
  }

  static confirmStopGameDialog(BuildContext context, Function onTap) {
    showModalBottomSheet(
      backgroundColor: Constants.darkControllerColor,
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.45,
          child: ConfirmStopGameDialog(
            onTap: onTap,
          ),
        );
      },
    );
  }

  /*蓝牙断开连接弹窗*/
  static blueToothDeviceDisconnectedDialog(BuildContext context) {
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
            child: BlueToothDeviceDisconnectedDialog(),
          ),
        );
      },
    );
  }

  /*电量过低提示弹窗*/
  static lowPowerTipDialog(BuildContext context,
      {int boardIndex = 0, int powerValue = 0,bool isErQiLing = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(left: 32,right: 32),
            decoration: BoxDecoration(
              color: hexStringToColor('#3E3E55'),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: LowPowerTipDialog(boardIndex: boardIndex, powerValue: powerValue,isErQiLing: isErQiLing,),
          ),
        );
      },
    );
  }
}
