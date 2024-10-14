import 'package:code/models/airbattle/p3_item_model.dart';
import 'package:code/models/ble/ble_model.dart';
import 'package:code/services/http/airbattle.dart';
import 'package:code/services/http/participants.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

// 这个顺序需要和后台管理上的数据的dickey的场景值的顺序保持一致
enum GameScene { five, erqiling, threee }

class GameUtil {
  GameScene gameScene = GameScene.erqiling; // 默认为五节控球器
  bool fiveLowPower1 = false; // 第一次低电量提示
  bool fiveLowPower2 = false; // 第二次低电量提示
  bool uliLowPower1 = false; // 第一次低电量提示
  bool uliLowPower2 = false; // 第二次低电量提示
  int modelId = 0; // 场景下对应的模式模式
  bool nowISGamePage = false; // 是否在游戏页面，如果不在，收到了蓝牙的响应数据则不处理
  bool selectRecord = false; // 是否选择录制视频
  bool isFromAirBattle = false; // 是否是AirBattle
  String firebaseToken = ''; // firebase 推送的token
  ActivityModel activityModel = ActivityModel(); // 当前的ActivityModel
  bool hasShowNitice = false; // 是否已经展示首页获奖弹窗
  BLEModel selectedDeviceModel = BLEModel(deviceName: 'deviceName'); // 选择的游戏设备
  BleStatus bleStatus = BleStatus.unknown; // 蓝牙的状态
  double get imageWidth {
    if (this.modelId == 1) {
      return 200;
    } else if (this.modelId == 6) {
      return 64;
    } else if (this.modelId == 7) {
      return 128;
    }
    return 0;
  }

  double get gameImageWidth {
    if (this.modelId == 1) {
      return 128;
    } else if (this.modelId == 6) {
      return 64;
    }
    return 0;
  }

  List<SceneModel> sceneList = [
    SceneModel(),
    SceneModel(
        dictKey: '1',
        dictValue: 'Digital Stickhandling Trainer',
        dictRemark:
            'Sharpen your stickhandling and reaction time with interactive challenges that also encourage you to glance up and maintain awareness. Watch yourself in action and perfect your technique in real-time.Select your challenge mode by shape, dive into quick tutorials, and push your limits.')
  ]; // 场景列表
  List<int> selectdP3Indexs = []; // 270P3模式选择的组合的索引
  List<P3ItemModel> selectdP3Items = []; // 270P3模式选择的组合的索引
}
