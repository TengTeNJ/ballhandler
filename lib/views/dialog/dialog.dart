import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/views/ble/ble_list_view.dart';
import 'package:code/widgets/account/cancel_button.dart';
import 'package:code/widgets/base/base_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

/**发送邮件弹窗**/
class SendEmailDiaog extends StatefulWidget {
  const SendEmailDiaog({super.key});

  @override
  State<SendEmailDiaog> createState() => _SendEmailDiaogState();
}

class _SendEmailDiaogState extends State<SendEmailDiaog> {
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
              child: Text(
                textAlign: TextAlign.center,
                'We sent an email to tommy009@163.com help You log in',
                style: TextStyle(
                  fontFamily: 'SanFranciscoDisplay',
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16, // 设置文本水平居中对齐
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
  const ExchangeIntegralDialog({super.key});

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
