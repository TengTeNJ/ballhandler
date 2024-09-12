import 'dart:async';

import 'package:code/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import 'blue_tooth_manager.dart';
import 'global.dart';
class ControlTimeOutUtil{
  int _retryTimes = 0;
  Completer<bool> completer = Completer();
  List<int> ongoingData = [];
  ValueNotifier<bool> controling = ValueNotifier<bool>(false);
  //bool controling = false; // 是否正在控制 而且没有返回
  Timer? timeOutTimer;
  int controlBoard = -1; //  控制的灯板 超时重发的不记录
  int _controlLedId = 0; // 控制等的索引 最大为255
  static final ControlTimeOutUtil _instance = ControlTimeOutUtil._internal();
  factory ControlTimeOutUtil() {
    return _instance;
  }
  ControlTimeOutUtil._internal();
  int  get retryTimes => _retryTimes;
  int  get controlLedId => _controlLedId;

/*改变重试的次数*/
  set retryTimes(int times){
    _retryTimes = times;
    if(_retryTimes > 5){
      TTToast.showErrorInfo('超时次数达到上限');
      ControlTimeOutUtil().controlLedId ++;
      this.completer.complete(true);
      reset();
    }else{
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, ControlTimeOutUtil().ongoingData);
      begainTimer();
    }
  }
  set controlLedId(int idValue){
    if(idValue > 255){
      idValue = 0;
    }
    _controlLedId = idValue;
  }
/*开始超时监听*/
  begainTimer(){
    if( this.timeOutTimer != null){
      this.timeOutTimer!.cancel();
      this.timeOutTimer = null;
    }
    this.timeOutTimer =  Timer(Duration(milliseconds: 200), (){
      this.retryTimes ++;
     print('超时${retryTimes}次---${controlLedId}');
    });
  }

  /*重置超时监听*/
  reset(){
    if( this.timeOutTimer != null){
      this.timeOutTimer!.cancel();
      this.timeOutTimer = null;
    }
    this._retryTimes = 0;
    this.ongoingData.clear();
    this.controling.value = false;
    ControlTimeOutUtil().completer = Completer<bool>();
  }
}