import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/views/ble/ble_list_view.dart';
import 'package:code/widgets/account/cancel_button.dart';
import 'package:code/widgets/base/base_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

import '../../utils/nsuserdefault_util.dart';

/**发送邮件弹窗**/
class SendEmailDiaog extends StatefulWidget {
  const SendEmailDiaog({super.key});

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
              right: 16,
              child: GestureDetector(
                onTap: () async {
                  print('Begain Scan');
                  if (Platform.isAndroid) {
                    PermissionStatus locationPermission =
                        await Permission.location.request();
                    PermissionStatus bleScan =
                        await Permission.bluetoothScan.request();
                    PermissionStatus bleConnect =
                        await Permission.bluetoothConnect.request();
                    if (locationPermission == PermissionStatus.granted &&
                        bleScan == PermissionStatus.granted &&
                        bleConnect == PermissionStatus.granted) {
                      BluetoothManager().startScan();
                    }
                  } else {
                    BluetoothManager().startScan();
                  }
                },
                child: Constants.regularBaseTextWidget('Scan', 16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [CancelButton()],
          ),
          SizedBox(
            height: 90,
          ),
          Constants.regularWhiteTextWidget('Points will be redeemed', 14),
          SizedBox(
            height: 97,
          ),
          BaseButton(
              title: 'Confirm',
              height: 40,
              onTap: () {
                print('确认兑换');
                this.exchange();
              }),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [CancelButton()],
          ),
          SizedBox(
            height: 66,
          ),
          Constants.regularWhiteTextWidget('Exchange Successful', 20),
          SizedBox(
            height: 20,
          ),
          Constants.regularWhiteTextWidget(
              'We sent an email to ${UserProvider.of(context).email} help You Receive a reward.',
              14),
          SizedBox(
            height: 60,
          ),
          BaseButton(
              title: 'Close',
              height: 40,
              onTap: () {
                NavigatorUtil.pop();
              }),
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
  const ChampionDialog({super.key});

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
          Constants.customTextWidget('CHAMPION', 24, '#FBBA00'),
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
          BaseButton(
              title: 'Got It',
              height: 40,
              onTap: () {
                print('Got It');
              }),
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
  const AwardDialog({super.key});

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
        Container(
          width: 209,
          height: 40,
          child: Center(
            child: Constants.regularWhiteTextWidget('Got It', 16),
          ),
          decoration: BoxDecoration(
              color: Constants.baseStyleColor,
              borderRadius: BorderRadius.circular(10)),
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
  TimeSelectDialog({this.datePickerSelect,this.confirm,this.selectIndex = 0,this.startTime,this.endTime});

  @override
  State<TimeSelectDialog> createState() => _TimeSelectDialogState();
}

class _TimeSelectDialogState extends State<TimeSelectDialog> {
  int _selectIndex = 0;
  int _timeSelectIndex = 0; // 当选择自定义时，标记选择的时开始还是结束 1开始 2结束
  DateTime _selectedDate = DateTime.now();
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
    endTimer =  widget.endTime != null  ? widget.endTime!:StringUtil.dateToString(yesterday);
    // 过去七天的第一天的时间
    DateTime beforeSeven = yesterday.subtract(Duration(days: 7));
    startTime =  widget.startTime != null  ? widget.startTime!:StringUtil.dateToString(beforeSeven);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    if (widget.datePickerSelect != null) {
                      widget.datePickerSelect!(false);
                    }
                    _timeSelectIndex = 0;
                    _selectIndex = 0;

                    DateTime yesterday = _selectedDate.subtract(Duration(days: 1));
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
                    if (widget.datePickerSelect != null) {
                      widget.datePickerSelect!(false);
                    }
                    _timeSelectIndex = 0;
                    _selectIndex = 1;
                    DateTime yesterday = _selectedDate.subtract(Duration(days: 1));
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
                    if (widget.datePickerSelect != null) {
                      widget.datePickerSelect!(false);
                    }
                    _timeSelectIndex = 0;
                    _selectIndex = 2;
                    DateTime yesterday = _selectedDate.subtract(Duration(days: 1));
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
                    setState(() {

                    });
                    return;
                  }
                  _selectIndex = -1;
                  _timeSelectIndex = 1;
                  setState(() {});
                  if (widget.datePickerSelect != null) {
                    widget.datePickerSelect!(true);
                  }
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
                        _timeSelectIndex == 1 ? Icon(Icons.keyboard_arrow_down,color: Constants.baseStyleColor,) :Icon(Icons.chevron_right,color: Constants.baseGreyStyleColor,),
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
                    setState(() {

                    });
                    return;
                  }
                  _selectIndex = -1;
                  _timeSelectIndex = 2;
                  setState(() {});
                  if (widget.datePickerSelect != null) {
                    widget.datePickerSelect!(true);
                  }
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
                        _timeSelectIndex == 2 ? Icon(Icons.keyboard_arrow_down,color: Constants.baseStyleColor,) :Icon(Icons.chevron_right,color: Constants.baseGreyStyleColor,),
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
          Constants.regularGreyTextWidget(
              'Only six months of data are available', 10),
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
                    maxDateTime: _selectedDate,
                    initDateTime: _selectedDate,
                    locale: DateTimePickerLocale.en_us,
                    dateFormat:
                        'MMMM-dd-yyyy', // 这里的MMMM需要又4个，两个的话仍然显示数字月份.3个的话显示缩写的英文月份
                  )),
                )// 时间弹窗
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
              
              if(widget.confirm != null){
                widget.confirm!(startTime.replaceAll('/', '-'),endTimer.replaceAll('/', '-'),_selectIndex);
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
          ),// Confirm按钮
          SizedBox(
            height: 32,
          ),
        ],
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
            onTap: () {
              this.goToSetting();
            },
            child: RichText(
              text: TextSpan(
                text: 'You will compete in the',
                style: TextStyle(
                    color: Constants.baseGreyStyleColor,
                    fontFamily: 'SanFranciscoDisplay',
                    fontSize: 16,
                    height: 1.0,
                    fontWeight: FontWeight.w400),
                children: <TextSpan>[
                  TextSpan(
                    text: ' 10 year old',
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
  const UserNameDialog({super.key});

  @override
  State<UserNameDialog> createState() => _UserNameDialogState();
}

class _UserNameDialogState extends State<UserNameDialog> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Constants.boldBlackTextWidget('Enter your text', 20,textAlign: TextAlign.left),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
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
            String password = _passwordController.text;
            print('Username: $username, Password: $password');
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
    _passwordController.dispose();
    super.dispose();
  }
}
