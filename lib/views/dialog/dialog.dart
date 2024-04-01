import 'package:code/constants/constants.dart';
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
