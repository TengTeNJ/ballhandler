import 'dart:async';
import 'package:code/constants/constants.dart';
import 'package:code/utils/blue_tooth_manager.dart';

import 'ble_ultimate_data.dart';
import 'ble_util.dart';
import 'notification_bloc.dart';
enum CheckResult { checking, success, error }
class BoardOnlineUtil{
  Function? checkResult;
  StreamSubscription? subscription;
  int _count = 0; // 查询次数
  Timer? _timer;
  /*监测查询各个板子的连接在线状态*/
  startCheckOnlineStatu(){
   //clearHandle();
    // 立刻进行一次数据请求
    // 查询各板子状态
    Future.delayed(Duration(milliseconds: 200),(){
      BleUtil.queryBoardOnlineStatu();
    });
    subscription = EventBus().stream.listen((event) async{
      if(event == kBoardOnLineStatu){
        // 判断数组中的所有元素是否都等于 1
        bool allEqualOne =  BluetoothManager().boardOnlineStatu .every((element) => element == 1);
        if(allEqualOne){
          _timer!.cancel();
          _count = 0;
          if(checkResult != null){
            subscription?.cancel();
            checkResult!(CheckResult.success);
          }
        }
      }
    });
  _timer = Timer.periodic(Duration(milliseconds: 1000), (Timer timer){
    _count ++;
    BleUtil.queryBoardOnlineStatu();
    if(_count >= 90){
      print('超时未连接');
      timer.cancel();
      _count = 0;
      if(checkResult != null){
        checkResult!(CheckResult.error);
      }
    }
  });
  }

  clearHandle(){
    _timer?.cancel();
    _count = 0;
    if(checkResult != null){
      checkResult = null;
    }
    subscription?.cancel();
  }
}