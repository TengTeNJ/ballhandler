import 'package:code/constants/constants.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';

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
