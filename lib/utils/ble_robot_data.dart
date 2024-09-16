import 'package:code/constants/constants.dart';
import 'package:code/models/game/hit_target_model.dart';


List<int> noticeRobotIndex(HitTargetModel hitModel) {
  String key = hitModel.boardIndex.toString() + hitModel.ledIndex.toString();
  int? index = kBoardIndexToRobotIndexMap[key];
  if (index == null) {
    return [];
  }
  int v = 0xA5 + 0x07 + 0x70 + 0x00 +  index!;
  List<int> values = [0xA5, 0x07, 0x71,0x00, index!, v, 0xAA];
  return values;
}


