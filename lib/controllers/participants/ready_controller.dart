import 'dart:async';

import 'package:code/constants/constants.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';

import '../../utils/color.dart';
import '../../utils/notification_bloc.dart';
import '../../utils/system_device.dart';
class ReadyController extends StatefulWidget {
  const ReadyController({super.key});

  @override
  State<ReadyController> createState() => _ReadyControllerState();
}

class _ReadyControllerState extends State<ReadyController> {
  late StreamSubscription subscription;
  String centerText = 'READY';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = EventBus().stream.listen((event){
      if(event == kGameReady){
        timerPeriodRefreshText();
      }
    });
  }
  /*倒计时刷新*/
  timerPeriodRefreshText(){
    int count = 3;
    setState(() {
      centerText = count.toString();
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
     count --;
     setState(() {
       if(count == 0){
         centerText = 'GO';
         Future.delayed(Duration(milliseconds: 100),(){
         //  NavigatorUtil.pop();
         });
         timer.cancel();
       }else{
         centerText = count.toString();
       }
     });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.baseControllerColor,
      body: Center(
        child: Constants.boldWhiteTextWidget(centerText, 75),
      ),
    );
  }
}
