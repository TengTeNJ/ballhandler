import 'package:code/models/ble/ble_model.dart';
import 'package:code/services/http/airbattle.dart';
import 'package:code/services/http/participants.dart';

enum GameScene { five, erqiling,threee}

class GameUtil {
  GameScene gameScene = GameScene.five; // 默认为五节控球器
  int modelId = 6; // 场景下对应的模式模式
  bool nowISGamePage = false; // 是否在游戏页面，如果不在，收到了蓝牙的响应数据则不处理
  bool selectRecord = false; // 是否选择录制视频
  bool isFromAirBattle = false; // 是否是AirBattle
  String firebaseToken = ''; // firebase 推送的token
  ActivityModel activityModel = ActivityModel(); // 当前的ActivityModel
  bool hasShowNitice = false; // 是否已经展示首页获奖弹窗
  BLEModel selectedDeviceModel = BLEModel(deviceName: 'deviceName'); // 选择的游戏设备
  double get imageWidth {
    if(this.modelId == 1){
      return 200;
    }else  if(this.modelId == 6){
      return 64;
    }else  if(this.modelId == 7){
      return 128;
    }
    return 0;
  }
  double get gameImageWidth {
    if(this.modelId == 1){
      return 128;
    }else  if(this.modelId == 6){
      return 64;
    }
    return 0;
  }
  List<SceneModel> sceneList = [SceneModel()]; // 场景列表
}
