import 'package:code/models/game/hit_target_model.dart';
import 'package:code/utils/ble_ultimate_service_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../utils/ble_data_service.dart';
import '../../utils/blue_tooth_manager.dart';

class GameData extends ChangeNotifier {
  bool _powerOn = false; // 开机状态
  int _currentTarget = 0; // 当前响应标靶,如果是270设备，则代表响应的几个板子的索引，0-5(0为主控板，1-5为从控板)
  int sendCurrentTarget = 0; // P3模式下 app端发送的控制的当前的板子的索引0-5(0为主控板，1-5为从控板)
  int _score = 0; // 得分
  int utimateGameSatatu = 0; // 270模式游戏的状态0x00-IDLE(选择模式状态)；0x01-游戏预备；0x02-游戏开始；0x03-游戏结束
  bool _gameStart = false; // 游戏状态
  int _powerValue = 100; // 电量值
  int _remainTime = 45; // 剩余时长
  int _millSecond = 0; // 剩余时长
  String _showRemainTime = '00:45'; // 需要在UI上显示的剩余时长的格式
  HitTargetModel? hitTargetModel; // 击中的面板的灯的数据模型
  int singleLedIndex = 0; // 刷新某面板上单个led时的led的索引
  BleULTimateLighStatu singleLedStatu = BleULTimateLighStatu.close; // 刷新某面板上单个led时的led的状态
  /* get方法 */
  bool get powerOn => _powerOn;

  int get currentTarget => _currentTarget;

  int get score => _score;

  int get powerValue => _powerValue;

  bool get gameStart => _gameStart;

  int get remainTime => _remainTime;

  int get millSecond => _millSecond;

  List<BleULTimateLighStatu> lightStatus = [
    BleULTimateLighStatu.close,
    BleULTimateLighStatu.close,
    BleULTimateLighStatu.close,
    BleULTimateLighStatu.close
  ]; // 当前面板的四个灯的状态,仅仅270设备有效

  List<BleULTimateLighStatu> sendLightStatus = [
    BleULTimateLighStatu.close,
    BleULTimateLighStatu.close,
    BleULTimateLighStatu.close,
    BleULTimateLighStatu.close
  ]; // P3模式下  app端发送当前面板的四个灯的状态,仅仅270设备有效

  List<int> p3DeviceBatteryValues = [100,100,100,100,100,100]; // p3模式下 所有板子的电量，板子的序号为0 1 2 3 4 5
  bool ultimateIsGaming = false; // 270设备的是否在游戏状态 0x00-不在游戏状态，0x01-游戏状态

  String get showRemainTime => _showRemainTime;

  /* set方法*/
  set powerOn(bool powerOn) {
    _powerOn = powerOn;
  }

  set currentTarget(int currentTarget) {
    _currentTarget = currentTarget;
  }

  set score(int score) {
    if(score < 0){
      score = 0;
    }
    _score = score;
  }

  set powerValue(int powerValue) {
    _powerValue = powerValue;
  }

  set gameStart(bool gameStart) {
    _gameStart = gameStart;
  }

  set remainTime(int remainTime) {
    _remainTime = remainTime;
    notifyListeners();
    // _millSecond = 99;
    // 自动处理显示的剩余时长格字符串
    int minute = (remainTime / 60).toInt();
    int second = remainTime % 60;
    _showRemainTime =minute.toString().padLeft(2, '0') + ':' + second.toString().padLeft(2, '0');
    BluetoothManager().triggerCallback(type: BLEDataType.remainTime);
  }

  set millSecond(int millSecond) {
    _millSecond = millSecond;
    notifyListeners();
    _showRemainTime = '00:' +
        _remainTime.toString().padLeft(2, '0') +
        _millSecond.toString().padLeft(2, '0');
  }

  set showRemainTime(String showRemainTime) {
    _showRemainTime = showRemainTime;
  }
}

// 创建一个全局的Provider
class GamedDataProvider extends StatelessWidget {
  final Widget child;

  GamedDataProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameData(),
      child: child,
    );
  }

  static GameData of(BuildContext context) {
    return Provider.of<GameData>(context, listen: false);
  }
}
