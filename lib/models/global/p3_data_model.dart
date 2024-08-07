import 'package:code/models/game/hit_target_model.dart';

class P3DataModel {
  int boardIndex = -1; // 灯板编号 0,1,2,3,4,5  其中0是central  其他是从机Slave  -1代表不在游戏中
  List<HitTargetModel> currentControlLeds = []; // 当前控制的灯的信息
  int gameIndex =
      -1; // 游戏的索引，比如p3选择了三种模式，按照选择的顺序进行，分别为，0，1，2 每个模式结束进行下一轮。
}
