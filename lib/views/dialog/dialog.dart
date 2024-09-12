import 'dart:async';
import 'dart:convert';

import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/route/route.dart';
import 'package:code/services/http/account.dart';
import 'package:code/utils/app_purse.dart';
import 'package:code/utils/ble_util.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/utils/toast.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:code/views/ble/ble_list_view.dart';
import 'package:code/views/participants/subscribe_border_view.dart';
import 'package:code/widgets/account/cancel_button.dart';
import 'package:code/widgets/base/base_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:tt_indicator/tt_indicator.dart';
import '../../models/ble/ble_model.dart';
import '../../utils/nsuserdefault_util.dart';
import 'package:flutter_to_airplay/flutter_to_airplay.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../utils/upd_util.dart';

/**发送邮件弹窗**/
class SendEmailDiaog extends StatefulWidget {
  Function? confirm;

  SendEmailDiaog({this.confirm});

  @override
  State<SendEmailDiaog> createState() => _SendEmailDiaogState();
}

class _SendEmailDiaogState extends State<SendEmailDiaog> {
  String _email = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInputEmailText();
  }

  getInputEmailText() async {
    final _text = await NSUserDefault.getValue<String>(kInputEmail);
    _email = _text ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Constants.darkControllerColor),
      child: Stack(
        children: [
          Positioned(
              top: 8,
              left: (Constants.screenWidth(context) - 80) / 2.0,
              child: Container(
                  width: 80,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color.fromRGBO(89, 105, 138, 0.4),
                  ))),
          Positioned(
              child: Container(
                child: Center(
                  child:
                      Constants.mediumWhiteTextWidget('Check your email', 20),
                ),
              ),
              top: 73,
              width: Constants.screenWidth(context)),
          Positioned(
            child: Container(
              width: Constants.screenWidth(context),
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  textAlign: TextAlign.center,
                  'We sent an email to ${_email} help You log in',
                  style: TextStyle(
                    fontFamily: 'SanFranciscoDisplay',
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16, // 设置文本水平居中对齐
                  ),
                ),
              ),
            ),
            top: 118,
          ),
          Positioned(
            child: GestureDetector(
              onTap: () {
                NavigatorUtil.pop();
                if (widget.confirm != null) {
                  widget.confirm!();
                }
              },
              child: Container(
                child: Center(
                  child: Constants.regularWhiteTextWidget('Cancel', 16),
                ),
                decoration: BoxDecoration(
                    color: Constants.baseStyleColor,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            left: 83,
            right: 83,
            bottom: 42,
            height: 40,
          )
        ],
      ),
    );
  }
}

/**发送邮件弹窗**/
class IpadSendEmailDiaog extends StatefulWidget {
  Function? confirm;

  IpadSendEmailDiaog({this.confirm});

  @override
  State<IpadSendEmailDiaog> createState() => _IpadSendEmailDiaogState();
}

class _IpadSendEmailDiaogState extends State<IpadSendEmailDiaog> {
  String _email = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInputEmailText();
  }

  getInputEmailText() async {
    final _text = await NSUserDefault.getValue<String>(kInputEmail);
    _email = _text ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Constants.darkControllerColor),
      child: Stack(
        children: [
          Positioned(
              top: 8,
              left: 32,
              right: 32,
              child: Container(
                  width: 80,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color.fromRGBO(89, 105, 138, 0.4),
                  ))),
          Positioned(
            child: Container(
              width: 300,
              child: Center(
                child: Constants.mediumWhiteTextWidget('Check your email', 20,
                    textAlign: TextAlign.center),
              ),
            ),
            top: 73,
            left: 32,
            right: 32,
          ),
          Positioned(
            child: Container(
              width: Constants.screenWidth(context),
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  textAlign: TextAlign.center,
                  'We sent an email to ${_email} help You log in',
                  style: TextStyle(
                    fontFamily: 'SanFranciscoDisplay',
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16, // 设置文本水平居中对齐
                  ),
                ),
              ),
            ),
            top: 118,
            left: 32,
            right: 32,
          ),
          Positioned(
            child: GestureDetector(
              onTap: () {
                NavigatorUtil.pop();
                if (widget.confirm != null) {
                  widget.confirm!();
                }
              },
              child: Container(
                child: Center(
                  child: Constants.regularWhiteTextWidget('Cancel', 16),
                ),
                decoration: BoxDecoration(
                    color: Constants.baseStyleColor,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            left: 83,
            right: 83,
            bottom: 42,
            height: 40,
          )
        ],
      ),
    );
  }
}

/**蓝牙列表弹窗**/
class BLEListDialog extends StatefulWidget {
  const BLEListDialog({super.key});

  @override
  State<BLEListDialog> createState() => _BLEListDialogState();
}

class _BLEListDialogState extends State<BLEListDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Constants.darkControllerColor),
      child: Stack(
        children: [
          Positioned(
              top: 8,
              left: (Constants.screenWidth(context) - 80) / 2.0,
              child: Container(
                  width: 80,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color.fromRGBO(89, 105, 138, 0.4),
                  ))),
          Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  print('断开连接 break');
                  if (BluetoothManager().hasConnectedDeviceList.length ==
                      1) {
                    BLEModel model =
                    BluetoothManager().hasConnectedDeviceList[0];
                    BluetoothManager().disconecteDevice(model);
                  }else{
                    print('未有连接蓝牙设备');
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 20,
                      child: Constants.regularBaseTextWidget('Break', 16,
                          textAlign: TextAlign.start),
                    )
                  ],
                ),
              )),
          Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  print('begain scan');
                  BleUtil.begainScan(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 20,
                      child: Constants.regularBaseTextWidget('Scan', 16,
                          textAlign: TextAlign.end),
                    )
                  ],
                ),
              )),
          Positioned(
            child: BLEListView(),
            top: 45,
            bottom: 99,
          ),
          Positioned(
            child: GestureDetector(
              onTap: () {
                NavigatorUtil.pop();
              },
              child: Container(
                child: Center(
                  child: Constants.regularWhiteTextWidget('Cancel', 16),
                ),
                decoration: BoxDecoration(
                    color: Constants.baseStyleColor,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            left: 83,
            right: 83,
            bottom: 42,
            height: 40,
          )
        ],
      ),
    );
  }
}

class IpadBLEListDialog extends StatefulWidget {
  const IpadBLEListDialog({super.key});

  @override
  State<IpadBLEListDialog> createState() => _IpadBLEListDialogState();
}

class _IpadBLEListDialogState extends State<IpadBLEListDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Constants.darkControllerColor),
      child: Stack(
        children: [
          Positioned(
              top: 8,
              left: 32,
              right: 32,
              child: Container(
                  width: 80,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color.fromRGBO(89, 105, 138, 0.4),
                  ))),
          Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  print('断开连接 break');
                  if (BluetoothManager().hasConnectedDeviceList.length ==
                      1) {
                    BLEModel model =
                    BluetoothManager().hasConnectedDeviceList[0];
                    BluetoothManager().disconecteDevice(model);
                  }else{
                    print('未有连接蓝牙设备');
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 20,
                      child: Constants.regularBaseTextWidget('Break', 16,
                          textAlign: TextAlign.start),
                    )
                  ],
                ),
              )),
          Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  print('begain scan');
                  BleUtil.begainScan(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 20,
                      child: Constants.regularBaseTextWidget('Scan', 16,
                          textAlign: TextAlign.end),
                    )
                  ],
                ),
              )),
          Positioned(
            child: BLEListView(),
            top: 45,
            bottom: 99,
          ),
          Positioned(
            child: GestureDetector(
              onTap: () {
                NavigatorUtil.pop();
              },
              child: Container(
                child: Center(
                  child: Constants.regularWhiteTextWidget('Cancel', 16),
                ),
                decoration: BoxDecoration(
                    color: Constants.baseStyleColor,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            left: 83,
            right: 83,
            bottom: 42,
            height: 40,
          )
        ],
      ),
    );
  }
}

/*积分兑换弹窗 ExchangeIntegralDialog*/
class ExchangeIntegralDialog extends StatelessWidget {
  Function exchange;

  ExchangeIntegralDialog({required this.exchange});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 90,
          ),
          Constants.regularWhiteTextWidget('Points will be redeemed', 14),
          SizedBox(
            height: 97,
          ),
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: BaseButton(
                borderRadius: BorderRadius.circular(5),
                title: 'Confirm',
                height: 40,
                onTap: () {
                  print('确认兑换');
                  this.exchange();
                }),
          ),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}

/*积分兑换成功弹窗 ExchangeIntegralDialog*/
class ExchangeIntegralSuccessDialog extends StatelessWidget {
  const ExchangeIntegralSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 66,
          ),
          Constants.boldWhiteTextWidget('Exchange Successful', 20),
          SizedBox(
            height: 20,
          ),
          Constants.regularWhiteTextWidget(
              'We sent an email to ${UserProvider.of(context).email} help You Receive a reward.',
              14),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: BaseButton(
                borderRadius: BorderRadius.circular(5),
                title: 'Close',
                height: 40,
                onTap: () {
                  NavigatorUtil.pop();
                }),
          ),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}

/*冠军得奖弹窗ChampionDialog*/
class ChampionDialog extends StatelessWidget {
  Function? gotIt;

  ChampionDialog({this.gotIt});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 120,
                width: 200,
                // color: Colors.red,
                child: Stack(
                  children: [
                    Image(
                      image: AssetImage('images/participants/fireworks.png'),
                      height: 120,
                      width: 200,
                    ),
                    Positioned(
                        left: 56,
                        top: 44,
                        child: Image(
                          image: AssetImage('images/participants/champion.png'),
                          width: 88,
                          height: 76,
                        ))
                  ],
                ),
              ),
              CancelButton()
            ],
          ),
          SizedBox(
            height: 36,
          ),
          Constants.customTextWidget('CHAMPION', 24, '#FBBA00',
              fontWeight: FontWeight.bold),
          SizedBox(
            height: 18,
          ),
          Constants.customTextWidget(
              'Congratulations on winning the cham -pionship in this Air Battle',
              14,
              '#FFFFFF',
              height: 1.5),
          SizedBox(
            height: 44,
          ),
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: BaseButton(
                title: 'Got It',
                height: 40,
                onTap: () {
                  NavigatorUtil.pop();
                  if (gotIt != null) {
                    gotIt!();
                  }
                }),
          ),
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}

/*奖品确认弹窗*/
class AwardDialog extends StatelessWidget {
  Function? gotIt;

  AwardDialog({this.gotIt});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 8,
        ),
        Container(
            width: 80,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color.fromRGBO(89, 105, 138, 0.4),
            )),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/airbattle/gold.png'),
                width: 48,
                height: 48,
              ),
              SizedBox(
                height: 12,
              ),
              Constants.boldBaseTextWidget('Air Battle Champion Award', 16),
              SizedBox(
                height: 26,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Constants.customTextWidget(
                    'Congratulations on winning the championshipin this Air Battle We sent an email to ' +
                        UserProvider.of(context).email +
                        ' help You Receive a reward',
                    16,
                    '#FFFFFF',
                    height: 1.5),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            if (gotIt != null) {
              gotIt!();
            }
            NavigatorUtil.pop();
          },
          child: Container(
            width: 209,
            height: 40,
            child: Center(
              child: Constants.regularWhiteTextWidget('Got It', 16),
            ),
            decoration: BoxDecoration(
                color: Constants.baseStyleColor,
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(
          height: 44,
        )
      ],
    );
  }
}

/*时间选择弹窗*/
class TimeSelectDialog extends StatefulWidget {
  String? startTime;
  String? endTime;
  int selectIndex; // 标识选择的时7,30 还是90days
  Function? datePickerSelect;
  Function? confirm;

  TimeSelectDialog(
      {this.datePickerSelect,
      this.confirm,
      this.selectIndex = 0,
      this.startTime,
      this.endTime});

  @override
  State<TimeSelectDialog> createState() => _TimeSelectDialogState();
}

class _TimeSelectDialogState extends State<TimeSelectDialog> {
  int _selectIndex = 0;
  int _timeSelectIndex = 0; // 当选择自定义时，标记选择的时开始还是结束 1开始 2结束
  DateTime _selectedDate = DateTime.now();
  DateTime _maxDate = DateTime.now();
  late DateTime _yesterdayDate;

  late String startTime;
  late String endTimer;

  // 计算90天前的时间
  late DateTime _minDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectIndex = widget.selectIndex;
    _minDate = _selectedDate.subtract(Duration(days: 180));
    // 昨天的时间
    DateTime yesterday = _selectedDate.subtract(Duration(days: 1));
    _yesterdayDate = yesterday;
    endTimer = widget.endTime != null
        ? widget.endTime!
        : StringUtil.dateToString(yesterday);
    // 过去七天的第一天的时间
    DateTime beforeSeven = yesterday.subtract(Duration(days: 7));
    startTime = widget.startTime != null
        ? widget.startTime!
        : StringUtil.dateToString(beforeSeven);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [CancelButton()],
            ),
            SizedBox(
              height: 28,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // Last 7days
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      _timeSelectIndex = 0;
                      _selectIndex = 0;

                      DateTime yesterday =
                          _selectedDate.subtract(Duration(days: 1));
                      _yesterdayDate = yesterday;
                      endTimer = StringUtil.dateToString(yesterday);
                      // 过去七天的第一天的时间
                      DateTime beforeSeven =
                          _yesterdayDate.subtract(Duration(days: 7));
                      startTime = StringUtil.dateToString(beforeSeven);
                      setState(() {});
                    },
                    child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                            border: _selectIndex == 0
                                ? Border.all(
                                    color: hexStringToColor('#707070'),
                                    width: 0.0, // 设置边框宽度
                                  )
                                : Border.all(
                                    color: hexStringToColor('#707070'),
                                    width: 1.0, // 设置边框宽度
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            color: _selectIndex == 0
                                ? Constants.baseStyleColor
                                : hexStringToColor('#3E3E55')),
                        child: Center(
                          child: _selectIndex == 0
                              ? Constants.regularWhiteTextWidget(
                                  'Last 7 days', 14)
                              : Constants.regularGreyTextWidget(
                                  'Last 7 days', 14),
                        )),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // Last 30days
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      _timeSelectIndex = 0;
                      _selectIndex = 1;
                      DateTime yesterday =
                          _selectedDate.subtract(Duration(days: 1));
                      _yesterdayDate = yesterday;
                      endTimer = StringUtil.dateToString(yesterday);
                      // 过去30天的第一天的时间
                      DateTime beforeSeven =
                          _yesterdayDate.subtract(Duration(days: 30));
                      startTime = StringUtil.dateToString(beforeSeven);
                      setState(() {});
                    },
                    child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                            border: _selectIndex == 1
                                ? Border.all(
                                    color: hexStringToColor('#707070'),
                                    width: 0.0, // 设置边框宽度
                                  )
                                : Border.all(
                                    color: hexStringToColor('#707070'),
                                    width: 1.0, // 设置边框宽度
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            color: _selectIndex == 1
                                ? Constants.baseStyleColor
                                : hexStringToColor('#3E3E55')),
                        child: Center(
                          child: _selectIndex == 1
                              ? Constants.regularWhiteTextWidget(
                                  'Last 30 days', 14)
                              : Constants.regularGreyTextWidget(
                                  'Last 30 days', 14),
                        )),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // Last 90days
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      _timeSelectIndex = 0;
                      _selectIndex = 2;
                      DateTime yesterday =
                          _selectedDate.subtract(Duration(days: 1));
                      _yesterdayDate = yesterday;
                      endTimer = StringUtil.dateToString(yesterday);
                      // 过去90天的第一天的时间
                      DateTime beforeSeven =
                          _yesterdayDate.subtract(Duration(days: 90));
                      startTime = StringUtil.dateToString(beforeSeven);
                      setState(() {});
                    },
                    child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                            border: _selectIndex == 2
                                ? Border.all(
                                    color: hexStringToColor('#707070'),
                                    width: 0.0, // 设置边框宽度
                                  )
                                : Border.all(
                                    color: hexStringToColor('#707070'),
                                    width: 1.0, // 设置边框宽度
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            color: _selectIndex == 2
                                ? Constants.baseStyleColor
                                : hexStringToColor('#3E3E55')),
                        child: Center(
                          child: _selectIndex == 2
                              ? Constants.regularWhiteTextWidget(
                                  'Last 90 days', 14)
                              : Constants.regularGreyTextWidget(
                                  'Last 90 days', 14),
                        )),
                  ),
                  flex: 1,
                ),
              ],
            ),
            SizedBox(
              height: 48,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_timeSelectIndex == 1) {
                      _timeSelectIndex = 0;
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      setState(() {});
                      return;
                    }
                    _selectIndex = -1;
                    _timeSelectIndex = 0; // 如果时间选择弹窗正在显示，先让收起
                    setState(() {});

                    Future.delayed(Duration(milliseconds: 100), () {
                      _selectedDate = StringUtil.stringToDate(startTime);
                      _timeSelectIndex = 1;
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(true);
                      }
                      setState(() {});
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Constants.regularWhiteTextWidget(startTime, 16),
                          SizedBox(
                            width: 8,
                          ),
                          _timeSelectIndex == 1
                              ? Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Constants.baseStyleColor,
                                )
                              : Icon(
                                  Icons.chevron_right,
                                  color: Constants.baseGreyStyleColor,
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        color: hexStringToColor('#707070'),
                        height: 0.5,
                        width: (Constants.screenWidth(context) - 90) / 2.0,
                      )
                    ],
                  ),
                ),
                Constants.regularGreyTextWidget('To', 14, height: 0.8),
                GestureDetector(
                  onTap: () {
                    if (_timeSelectIndex == 2) {
                      _timeSelectIndex = 0;
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      setState(() {});
                      return;
                    }
                    _selectIndex = -1;
                    _timeSelectIndex = 0; // 如果时间选择弹窗正在显示，先让收起
                    setState(() {});
                    Future.delayed(Duration(milliseconds: 100), () {
                      _selectedDate = StringUtil.stringToDate(endTimer);
                      _timeSelectIndex = 2;
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(true);
                      }
                      setState(() {});
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Constants.regularWhiteTextWidget(endTimer, 16),
                          SizedBox(
                            width: 8,
                          ),
                          _timeSelectIndex == 2
                              ? Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Constants.baseStyleColor,
                                )
                              : Icon(
                                  Icons.chevron_right,
                                  color: Constants.baseGreyStyleColor,
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        color: hexStringToColor('#707070'),
                        height: 0.5,
                        width: (Constants.screenWidth(context) - 90) / 2.0,
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.help,
                  color: hexStringToColor('#B1B1B1'),
                  size: 12,
                ),
                SizedBox(
                  width: 4,
                ),
                Constants.regularGreyTextWidget(
                    'Only six months of data are available', 10),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            _timeSelectIndex >= 1
                ? Container(
                    color: Colors.red,
                    height: 220,
                    child: Center(
                        child: DateTimePickerWidget(
                      onChange: (DateTime dateTime, List<int> selectedIndex) {
                        if (_timeSelectIndex == 1) {
                          startTime = StringUtil.dateToString(dateTime);
                        } else if (_timeSelectIndex == 2) {
                          endTimer = StringUtil.dateToString(dateTime);
                        }
                        setState(() {});
                      },
                      pickerTheme: DateTimePickerTheme(
                          itemTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'SanFranciscoDisplay'),
                          backgroundColor: hexStringToColor('#3E3E55'),
                          titleHeight: 0,
                          itemHeight: 44,
                          pickerHeight: 220),
                      minDateTime: _minDate,
                      maxDateTime: _maxDate,
                      initDateTime: _selectedDate,
                      locale: DateTimePickerLocale.en_us,
                      dateFormat:
                          'MMM-dd-yyyy', // 这里的MMMM4个显示引英文全写，两个的话仍然显示数字月份.3个的话显示缩写的英文月份
                    )),
                  ) // 时间弹窗
                : Container(),
            _timeSelectIndex >= 1
                ? SizedBox(
                    height: 16,
                  )
                : SizedBox(
                    height: 0,
                  ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                DateTime startDate = StringUtil.stringToDate(startTime);
                DateTime endDate = StringUtil.stringToDate(endTimer);
                if (endDate.isBefore(startDate)) {
                  // 结束时间不能早于开始时间
                  TTToast.showToast(
                      'End time cannot be earlier than start time');
                  return;
                }
                if (widget.confirm != null) {
                  widget.confirm!(startTime.replaceAll('/', '-'),
                      endTimer.replaceAll('/', '-'), _selectIndex);
                }
                NavigatorUtil.pop();
              },
              child: Container(
                width: 210,
                height: 40,
                decoration: BoxDecoration(
                    color: Constants.baseStyleColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Constants.regularWhiteTextWidget('Confirm', 14),
                ),
              ),
            ), // Confirm按钮
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}

/*时间选择弹窗*/
class IpadTimeSelectDialog extends StatefulWidget {
  String? startTime;
  String? endTime;
  int selectIndex; // 标识选择的时7,30 还是90days
  Function? datePickerSelect;
  Function? confirm;

  IpadTimeSelectDialog(
      {this.datePickerSelect,
      this.confirm,
      this.selectIndex = 0,
      this.startTime,
      this.endTime});

  @override
  State<IpadTimeSelectDialog> createState() => _IpadTimeSelectDialogState();
}

class _IpadTimeSelectDialogState extends State<IpadTimeSelectDialog> {
  int _selectIndex = 0;
  int _timeSelectIndex = 0; // 当选择自定义时，标记选择的时开始还是结束 1开始 2结束
  DateTime _selectedDate = DateTime.now();
  DateTime _maxDate = DateTime.now();
  late DateTime _yesterdayDate;

  late String startTime;
  late String endTimer;

  // 计算90天前的时间
  late DateTime _minDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectIndex = widget.selectIndex;
    _minDate = _selectedDate.subtract(Duration(days: 180));
    // 昨天的时间
    DateTime yesterday = _selectedDate.subtract(Duration(days: 1));
    _yesterdayDate = yesterday;
    endTimer = widget.endTime != null
        ? widget.endTime!
        : StringUtil.dateToString(yesterday);
    // 过去七天的第一天的时间
    DateTime beforeSeven = yesterday.subtract(Duration(days: 7));
    startTime = widget.startTime != null
        ? widget.startTime!
        : StringUtil.dateToString(beforeSeven);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [CancelButton()],
            ),
            SizedBox(
              height: 28,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // Last 7days
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      _timeSelectIndex = 0;
                      _selectIndex = 0;

                      DateTime yesterday =
                          _selectedDate.subtract(Duration(days: 1));
                      _yesterdayDate = yesterday;
                      endTimer = StringUtil.dateToString(yesterday);
                      // 过去七天的第一天的时间
                      DateTime beforeSeven =
                          _yesterdayDate.subtract(Duration(days: 7));
                      startTime = StringUtil.dateToString(beforeSeven);
                      setState(() {});
                    },
                    child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                            border: _selectIndex == 0
                                ? Border.all(
                                    color: hexStringToColor('#707070'),
                                    width: 0.0, // 设置边框宽度
                                  )
                                : Border.all(
                                    color: hexStringToColor('#707070'),
                                    width: 1.0, // 设置边框宽度
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            color: _selectIndex == 0
                                ? Constants.baseStyleColor
                                : hexStringToColor('#3E3E55')),
                        child: Center(
                          child: _selectIndex == 0
                              ? Constants.regularWhiteTextWidget(
                                  'Last 7 days', 14)
                              : Constants.regularGreyTextWidget(
                                  'Last 7 days', 14),
                        )),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // Last 30days
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      _timeSelectIndex = 0;
                      _selectIndex = 1;
                      DateTime yesterday =
                          _selectedDate.subtract(Duration(days: 1));
                      _yesterdayDate = yesterday;
                      endTimer = StringUtil.dateToString(yesterday);
                      // 过去30天的第一天的时间
                      DateTime beforeSeven =
                          _yesterdayDate.subtract(Duration(days: 30));
                      startTime = StringUtil.dateToString(beforeSeven);
                      setState(() {});
                    },
                    child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                            border: _selectIndex == 1
                                ? Border.all(
                                    color: hexStringToColor('#707070'),
                                    width: 0.0, // 设置边框宽度
                                  )
                                : Border.all(
                                    color: hexStringToColor('#707070'),
                                    width: 1.0, // 设置边框宽度
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            color: _selectIndex == 1
                                ? Constants.baseStyleColor
                                : hexStringToColor('#3E3E55')),
                        child: Center(
                          child: _selectIndex == 1
                              ? Constants.regularWhiteTextWidget(
                                  'Last 30 days', 14)
                              : Constants.regularGreyTextWidget(
                                  'Last 30 days', 14),
                        )),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // Last 90days
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      _timeSelectIndex = 0;
                      _selectIndex = 2;
                      DateTime yesterday =
                          _selectedDate.subtract(Duration(days: 1));
                      _yesterdayDate = yesterday;
                      endTimer = StringUtil.dateToString(yesterday);
                      // 过去90天的第一天的时间
                      DateTime beforeSeven =
                          _yesterdayDate.subtract(Duration(days: 90));
                      startTime = StringUtil.dateToString(beforeSeven);
                      setState(() {});
                    },
                    child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                            border: _selectIndex == 2
                                ? Border.all(
                                    color: hexStringToColor('#707070'),
                                    width: 0.0, // 设置边框宽度
                                  )
                                : Border.all(
                                    color: hexStringToColor('#707070'),
                                    width: 1.0, // 设置边框宽度
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            color: _selectIndex == 2
                                ? Constants.baseStyleColor
                                : hexStringToColor('#3E3E55')),
                        child: Center(
                          child: _selectIndex == 2
                              ? Constants.regularWhiteTextWidget(
                                  'Last 90 days', 14)
                              : Constants.regularGreyTextWidget(
                                  'Last 90 days', 14),
                        )),
                  ),
                  flex: 1,
                ),
              ],
            ),
            SizedBox(
              height: 48,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_timeSelectIndex == 1) {
                      _timeSelectIndex = 0;
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      setState(() {});
                      return;
                    }
                    _selectIndex = -1;
                    _timeSelectIndex = 0; // 如果时间选择弹窗正在显示，先让收起
                    setState(() {});

                    Future.delayed(Duration(milliseconds: 100), () {
                      _selectedDate = StringUtil.stringToDate(startTime);
                      _timeSelectIndex = 1;
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(true);
                      }
                      setState(() {});
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Constants.regularWhiteTextWidget(startTime, 16),
                          SizedBox(
                            width: 8,
                          ),
                          _timeSelectIndex == 1
                              ? Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Constants.baseStyleColor,
                                )
                              : Icon(
                                  Icons.chevron_right,
                                  color: Constants.baseGreyStyleColor,
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        color: hexStringToColor('#707070'),
                        height: 0.5,
                        width: 160,
                      )
                    ],
                  ),
                ),
                Constants.regularGreyTextWidget('To', 14, height: 0.8),
                GestureDetector(
                  onTap: () {
                    if (_timeSelectIndex == 2) {
                      _timeSelectIndex = 0;
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      setState(() {});
                      return;
                    }
                    _selectIndex = -1;
                    _timeSelectIndex = 0; // 如果时间选择弹窗正在显示，先让收起
                    setState(() {});
                    Future.delayed(Duration(milliseconds: 100), () {
                      _selectedDate = StringUtil.stringToDate(endTimer);
                      _timeSelectIndex = 2;
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(true);
                      }
                      setState(() {});
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Constants.regularWhiteTextWidget(endTimer, 16),
                          SizedBox(
                            width: 8,
                          ),
                          _timeSelectIndex == 2
                              ? Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Constants.baseStyleColor,
                                )
                              : Icon(
                                  Icons.chevron_right,
                                  color: Constants.baseGreyStyleColor,
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                          color: hexStringToColor('#707070'),
                          height: 0.5,
                          width: 160)
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.help,
                  color: hexStringToColor('#B1B1B1'),
                  size: 12,
                ),
                SizedBox(
                  width: 4,
                ),
                Constants.regularGreyTextWidget(
                    'Only six months of data are available', 10),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            _timeSelectIndex >= 1
                ? Container(
                    color: Colors.red,
                    height: 220,
                    child: Center(
                        child: DateTimePickerWidget(
                      onChange: (DateTime dateTime, List<int> selectedIndex) {
                        if (_timeSelectIndex == 1) {
                          startTime = StringUtil.dateToString(dateTime);
                        } else if (_timeSelectIndex == 2) {
                          endTimer = StringUtil.dateToString(dateTime);
                        }
                        setState(() {});
                      },
                      pickerTheme: DateTimePickerTheme(
                          itemTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'SanFranciscoDisplay'),
                          backgroundColor: hexStringToColor('#3E3E55'),
                          titleHeight: 0,
                          itemHeight: 44,
                          pickerHeight: 220),
                      minDateTime: _minDate,
                      maxDateTime: _maxDate,
                      initDateTime: _selectedDate,
                      locale: DateTimePickerLocale.en_us,
                      dateFormat:
                          'MMM-dd-yyyy', // 这里的MMMM4个显示引英文全写，两个的话仍然显示数字月份.3个的话显示缩写的英文月份
                    )),
                  ) // 时间弹窗
                : Container(),
            _timeSelectIndex >= 1
                ? SizedBox(
                    height: 16,
                  )
                : SizedBox(
                    height: 0,
                  ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                DateTime startDate = StringUtil.stringToDate(startTime);
                DateTime endDate = StringUtil.stringToDate(endTimer);
                if (endDate.isBefore(startDate)) {
                  // 结束时间不能早于开始时间
                  TTToast.showToast(
                      'End time cannot be earlier than start time');
                  return;
                }
                if (widget.confirm != null) {
                  widget.confirm!(startTime.replaceAll('/', '-'),
                      endTimer.replaceAll('/', '-'), _selectIndex);
                }
                NavigatorUtil.pop();
              },
              child: Container(
                width: 210,
                height: 40,
                decoration: BoxDecoration(
                    color: Constants.baseStyleColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Constants.regularWhiteTextWidget('Confirm', 14),
                ),
              ),
            ), // Confirm按钮
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}

/*加入Airbattle对战*/
class JoinAirBattleDialog extends StatelessWidget {
  Function continueClick;
  Function goToSetting;

  JoinAirBattleDialog({required this.continueClick, required this.goToSetting});

  @override
  Widget build(BuildContext context) {
    String group = UserProvider.of(context).group;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [CancelButton()],
          ),
          SizedBox(
            height: 42,
          ),
          Constants.mediumWhiteTextWidget('Join Battle', 20),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (goToSetting != null) {
                goToSetting();
              }
              ;
            },
            child: RichText(
              text: TextSpan(
                text: 'You will compete in the ',
                style: TextStyle(
                    color: Constants.baseGreyStyleColor,
                    fontFamily: 'SanFranciscoDisplay',
                    fontSize: 16,
                    height: 1.0,
                    fontWeight: FontWeight.w400),
                children: <TextSpan>[
                  TextSpan(
                    text: group,
                    style: TextStyle(
                      fontFamily: 'SanFranciscoDisplay',
                      fontSize: 16,
                      color: Constants.baseStyleColor,
                      height: 1.0,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: ' category',
                    style: TextStyle(
                      fontFamily: 'SanFranciscoDisplay',
                      fontSize: 16,
                      height: 1.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 106,
          ),
          Container(
            width: 210,
            child: BaseButton(
                linearGradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    hexStringToColor('#EF8914'),
                    hexStringToColor('#CF391A')
                  ],
                ),
                title: 'Continue',
                height: 40,
                onTap: () {
                  NavigatorUtil.pop();
                  this.continueClick();
                }),
          ),
          SizedBox(
            height: 42,
          ),
        ],
      ),
    );
  }
}

class UserNameDialog extends StatefulWidget {
  Function? confirm;

  UserNameDialog({this.confirm});

  @override
  State<UserNameDialog> createState() => _UserNameDialogState();
}

class _UserNameDialogState extends State<UserNameDialog> {
  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: hexStringToColor('#3E3E55'),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Constants.boldWhiteTextWidget('Enter your text', 20,
          textAlign: TextAlign.left),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            controller: _usernameController,
            decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            NavigatorUtil.pop();
          },
          child: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
                color: Constants.baseGreyStyleColor,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Constants.regularWhiteTextWidget('Cancel', 16),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            String username = _usernameController.text;
            if (widget.confirm != null) {
              widget.confirm!(username);
            }
            Navigator.of(context).pop();
          },
          child: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
                color: Constants.baseStyleColor,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Constants.regularWhiteTextWidget('Confirm', 16),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}

class AirPlayView extends StatelessWidget {
  const AirPlayView({super.key});

  @override
  Widget build(BuildContext context) {
    return AirPlayRoutePickerView(
      tintColor: Colors.white,
      activeTintColor: Colors.white,
      backgroundColor: Colors.transparent,
    );
  }
}

class VideoGuideDialog extends StatefulWidget {
  String videoPath;

  VideoGuideDialog({required this.videoPath});

  @override
  State<VideoGuideDialog> createState() => _VideoGuideDialogState();
}

class _VideoGuideDialogState extends State<VideoGuideDialog> {
  late final VideoPlayerController _controller;
  late ChewieController _chewieController;
  bool _loading = true;

  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.videoPath.contains('http')) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
            ..initialize().then((value) {
              print('加载完成');
              // 加载完成
              //_controller.play();
              _loading = false;
              setState(() {});
            });
    } else {
      File file = File(widget.videoPath);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((value) {
          // 加载完成
          // _controller.play();
          _loading = false;
          setState(() {});
        });
    }
    _chewieController = ChewieController(
      looping: true,
      videoPlayerController: _controller,
    );
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 64,
        ),
        Container(
          width: Constants.screenWidth(context),
          child: ClipRRect(
            child: AspectRatio(
              aspectRatio: Constants.screenWidth(context) /
                  (Constants.screenHeight(context) * 0.95 - 128),
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Chewie(controller: _chewieController),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        SizedBox(
          height: 64,
        )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
  }
}

class SubscribeDialog extends StatefulWidget {
  const SubscribeDialog({super.key});

  @override
  State<SubscribeDialog> createState() => _SubscribeDialogState();
}

class _SubscribeDialogState extends State<SubscribeDialog> {
  late PageController _pageController;
  AppPurse purse = AppPurse();
  int _currentIndex = 0;
  late StreamSubscription<dynamic> _subscription;
  List<ProductDetails> datas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 开始监听
    purse.startSubscription();
    // 查询订阅产品
    queryProducts();
    // 滑动指示器
    _pageController = PageController(initialPage: _currentIndex);
    // 滑动监听
    _pageController.addListener(() {
      int currentpage = _pageController.page!.round();
      _currentIndex = currentpage;
      // setState(() {});
    });
  }

  /*查询产品*/
  queryProducts() async {
    final _list = await purse.getAvaliableProductList();
    datas.addAll(_list);
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(odeBuildContecontext) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [CancelButton()],
            ),
            SizedBox(
              height: 20,
            ),
            Constants.boldWhiteTextWidget('Membership Options', 30),
            SizedBox(
              height: 40,
            ),
            Container(
              width: 446 / 306 * 153,
              height: 153,
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image(
                          image: AssetImage(
                              'images/launch/subscribe_${index + 1}.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 16,
            ),
            IndicatorView(
              count: 2,
              currentPage: _currentIndex,
              defaultColor: Color.fromRGBO(204, 204, 204, 1.0),
              currentPageColor: Constants.baseStyleColor,
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              child: datas.length == 0
                  ? NoDataView()
                  : ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return SubscribeBorderView(
                            leftTitle: datas[index].title,
                            rightTitle: (datas[index].rawPrice / 12.0)
                                .toStringAsFixed(2),
                            rightDes: datas[index].rawPrice.toStringAsFixed(2),
                            onTap: () async {
                              purse.begainBuy(datas[index]);
                            },
                          );
                        } else {
                          return SubscribeBorderView(
                            leftTitle: datas[index].title,
                            rightTitle:
                                datas[index].rawPrice.toStringAsFixed(2),
                            onTap: () async {
                              purse.begainBuy(datas[index]);
                            },
                          );
                        }
                        ;
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 24,
                        );
                      },
                      itemCount: datas.length),
              height: 152,
            ),
            SizedBox(
              height: 8,
            ),
            Constants.regularWhiteTextWidget(
                'Get a free Digital Stickhandling Trainer with a one-year membership',
                14,
                height: 1.25),
            SizedBox(
              height: 28,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    NavigatorUtil.push(Routes.membership);
                  },
                  child: Constants.mediumBaseTextWidget('Member Service', 16,
                      textAlign: TextAlign.end),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  height: 16,
                  width: 1,
                  decoration: BoxDecoration(
                      color: hexStringToColor('#707070'),
                      border: Border.all(
                          width: 1, color: hexStringToColor('#707070'))),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    NavigatorUtil.push(Routes.webview);
                  },
                  child: Constants.mediumBaseTextWidget('Terms of Service', 16,
                      textAlign: TextAlign.end),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    purse.disposeSubscription();
    super.dispose();
  }
}

class MirrorScreenDialog extends StatelessWidget {
  const MirrorScreenDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            margin: EdgeInsets.only(top: 8),
            width: 80,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color.fromRGBO(89, 105, 138, 0.4),
            )),
        Column(
          children: [
            Image(
              image: AssetImage('images/participants/screen.png'),
              width: 95,
            ),
            SizedBox(
              height: 28,
            ),
            Padding(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: Constants.regularWhiteTextWidget(
                  'Please use the screen mirroring function on your mobile phone for casting',
                  16,
                  height: 1.375),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 83, right: 83, bottom: 42),
          child: BaseButton(
            title: 'Got It',
            onTap: () {
              NavigatorUtil.pop();
            },
          ),
        )
      ],
    );
  }
}

class ConfirmStopGameDialog extends StatelessWidget {
  Function? onTap;

  ConfirmStopGameDialog({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 8,
            left: (Constants.screenWidth(context) - 80) / 2.0,
            child: Container(
                width: 80,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color.fromRGBO(89, 105, 138, 0.4),
                ))),
        Center(
          child: Constants.boldWhiteTextWidget(
              'Confirm to stop this challenge?', 20),
        ),
        Positioned(
            child: BaseButton(
              title: 'Confirm',
              onTap: () {
                if (onTap != null) {
                  onTap!();
                }
                NavigatorUtil.pop();
              },
            ),
            bottom: 42,
            left: Constants.screenWidth(context) * 0.22,
            right: Constants.screenWidth(context) * 0.22)
      ],
    );
  }
}

/*蓝牙设备断开连接的弹窗*/
class BlueToothDeviceDisconnectedDialog extends StatelessWidget {
  const BlueToothDeviceDisconnectedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 315,
      width: 279,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 54,
          ),
          Image(
            image: AssetImage('images/ble/ble_dis.png'),
            width: 26,
            height: 36,
          ),
          SizedBox(
            height: 24,
          ),
          Constants.boldWhiteTextWidget('Bluetooth Disconnected', 20),
          SizedBox(
            height: 12,
          ),
          Constants.regularWhiteTextWidget(
              'Bluetooth disconnected Please check your board', 14,
              height: 1.3),
          SizedBox(
            height: 48,
          ),
          BaseButton(
            title: 'Close',
            onTap: () {
              NavigatorUtil.pop();
            },
          )
        ],
      ),
    );
  }
}

/*低电量提示弹窗*/
class LowPowerTipDialog extends StatelessWidget {
  int boardIndex = 0;
  int powerValue = 0;
  bool isErQiLing;
  LowPowerTipDialog({required this.boardIndex, required this.powerValue,required this.isErQiLing});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 315,
      width: 279,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 54,
          ),
          Image(
            image: AssetImage('images/battery/battery_low.png'),
            width: 52,
          ),
          SizedBox(
            height: 24,
          ),
          Constants.boldWhiteTextWidget('Battery Low', 20),
          SizedBox(
            height: 12,
          ),
        RichText(
          text: TextSpan(
            text:  this.isErQiLing ? 'Board ${kP3DataAndProductIndexMap[boardIndex]} ' : '',
            style: TextStyle(
                color: Constants.baseStyleColor,
                fontFamily: 'SanFranciscoDisplay',
                fontSize: 14,
                height: 1.3,
                fontWeight: FontWeight.w400),
            children: <TextSpan>[
              TextSpan(
                text: '${powerValue}%  battery remaining Please recharge your board ',
                style: TextStyle(
                  fontFamily: 'SanFranciscoDisplay',
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.3,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
          SizedBox(
            height: 48,
          ),
          BaseButton(
            title: 'Close',
            onTap: () {
              NavigatorUtil.pop();
            },
          )
        ],
      ),
    );
  }
}
