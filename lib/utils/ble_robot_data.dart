import 'package:code/constants/constants.dart';
import 'package:code/models/game/hit_target_model.dart';


List<int> noticeRobotIndex(HitTargetModel hitModel) {
  String key = hitModel.boardIndex.toString() + hitModel.ledIndex.toString();
  int? index = kBoardIndexToRobotIndexMap[key];
  if (index == null) {
    return [];
  }
  int v = 0xA5 + 0x07 + 0x71 + 0x00 +  index!;
  List<int> values = [0xA5, 0x07, 0x71,0x00, index!, v, 0xAA];
  return values;
}

List<int> robotWarn(int boardIndex) {
  Map _map = {
    0:1,
    1:2,
    2:3,
    3:4,
    4:5,
    5:6
  };
  if (boardIndex == null) {
    return [];
  }
  int _index = _map[boardIndex];
  int v = 0xA5 + 0x08 + 0x70 + 0x01 +  _index + 0x00;
  List<int> values = [0xA5, 0x08, 0x70,0x01, _index, 0x00, v, 0xAA];
  return values;
}


