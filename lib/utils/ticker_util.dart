import 'dart:async';

import 'package:code/constants/constants.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
class TickerUtil {
  late AnimationController _controller;
  late Ticker _ticker;
  int duration = kGameDuration*100; // 单位20ms 所以*50
  TickerProvider vsync;
  Function callBack;
  Stopwatch _stopwatch = Stopwatch();

  late Timer _timer;

  TickerUtil({required this.vsync ,required this.callBack});
  start(){
    // 创建 AnimationController
    // _controller = AnimationController(
    //   vsync: vsync,
    //   duration: Duration(milliseconds: 10),
    //
    // );
    //
    // // 创建 Ticker
    // _ticker = Ticker((Duration duration) {
    //   this.duration = this.duration - 1;
    //   // 在每一帧开始时调用
    //   int second = ((this.duration/100).ceil().toInt())%60;
    //   int millSecond = this.duration%100;
    //   String countDownString = '00:'+ second.toString() + ':' + millSecond.toString();
    //   BluetoothManager().gameData.showRemainTime = countDownString;
    //   this.callBack();
    //   print('Tick: ${duration.inMilliseconds}ms');
    //   print('second=${second}\nmillSecond=${millSecond}');
    //
    // });
    //
    // // 启动 Ticker
    // _ticker.start();


      _timer = Timer.periodic(Duration(milliseconds: 10), _updateTime);

    if(!_stopwatch.isRunning){
      _stopwatch.start();
    }


  }

  stop(){
    this.duration =  kGameDuration*100;
    // _controller.dispose();
    // // 停止 Ticker
    // _ticker.stop();
    // _ticker.dispose();

    _stopwatch.stop();
    _timer.cancel();


  }

  void _updateTime(Timer timer) {
    print('_updateTime');
    if (_stopwatch.isRunning) {
      BluetoothManager().gameData.millSecond --;
      // print('isRunning---');
      // this.duration = this.duration - 1;
      // // 在每一帧开始时调用
      // int second = ((this.duration/100).ceil().toInt())%60;
      // int millSecond = this.duration%100;
      // String countDownString = '00:'+ second.toString() + ':' + millSecond.toString();
      // BluetoothManager().gameData.showRemainTime = countDownString;
      this.callBack();
    }
  }

}