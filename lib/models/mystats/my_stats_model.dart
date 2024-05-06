import '../../constants/constants.dart';

class MyStatsModel {
  num speed = 0.1; // 速度
  String gameTimer = 'Feb 4 , 2023'; // 数据对应的游戏时间
  String rank = '-'; // 本次数据对应的排名
  // String trainingMode = 'Training Mode '; // 游戏模式
  String indexString = '1';
  String modeId = '1';
  String sceneId = '1';
  bool selected = false; // 选中状态，用于标记数据选中
  String get trainingMode {
    if(kGameSceneAndModelMap[this.sceneId] != null){
      Map<String,String> _sceneMap = kGameSceneAndModelMap[this.sceneId]!;
      if(_sceneMap[this.modeId] != null){
        String _model = _sceneMap[this.modeId]!;
        return _model;
      }
    }
    return 'ZIGZAG Challenge';
}
}
