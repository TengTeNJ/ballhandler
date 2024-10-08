import 'package:code/constants/constants.dart';
import 'package:code/models/game/hit_target_model.dart';
import 'package:code/utils/p3_robot_test_util.dart';
/*通知亮灯位置*/
List<int> noticeRobotIndex(HitTargetModel hitModel) {
  String key = hitModel.boardIndex.toString() + hitModel.ledIndex.toString();
  int? index = kBoardIndexToRobotIndexMap[key];
  if (index == null) {
    return [];
  }
  int v = 0xA5 + 0x07 + 0x70 + 0x00 + 0x00 + index!;
  List<int> values = [0xA5, 0x07, 0x70, 0x00, 0x00, index!, v, 0xAA];
  return values;
}
// 电池电压低
List<int> robotWarn(int boardIndex) {
  Map _map = {0: 1, 1: 2, 2: 3, 3: 4, 4: 5, 5: 6};
  if (boardIndex == null) {
    return [];
  }
  int _index = _map[boardIndex];
  int v = 0xA5 + 0x08 + 0x70 + 0x01 + _index + 0x00;
  List<int> values = [0xA5, 0x08, 0x70, 0x01, _index, 0x00, v, 0xAA];
  return values;
}

// 亮灯一场
List<int> lightWarn() {
  // kBoardIndexToRobotIndexMap
  String key =  P3RobotTestUtil().randomModel.boardIndex.toString() + P3RobotTestUtil().randomModel.ledIndex.toString();
  int index = kBoardIndexToRobotIndexMap[key] ?? 0;
  int v = 0xA5 + 0x08 + 0x70 + 0x02 + index + 0x00;
  List<int> values = [0xA5, 0x08, 0x70, 0x02, index, 0x00, v, 0xAA];
  return values;
}
