import 'dart:async';
import 'package:code/constants/constants.dart';
import 'package:get_it/get_it.dart';
import 'blue_tooth_manager.dart';
import 'global.dart';
import 'notification_bloc.dart';

// 全局的命令管理器
class CommandManager {
  // 用于控制命令回复的流

  // 按顺序发送数组中的命令
  static Future<void> sendCommandsSequentially(List<List<int>> commands) async {
    for (List<int> command in commands) {
      print('112233');
      // 创建一个 Completer 来等待回复
      Completer<String> completer = Completer<String>();
      // 监听回复流
      late StreamSubscription<dynamic> subscription; // 声明 subscription

      subscription = EventBus().stream.listen((reply) {
        if( reply == kReceiveControlResponse){
          // 收到控制回复
          print('收到控制回复');
          subscription.cancel();
          completer.complete(reply);
        }
      });
      // 发送指令
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, command);
      // 等待 Completer 完成
      String reply = await completer.future;
      print("Processed reply: $reply");
    }
    print("All commands sent and received replies.");
  }
}

void main() async {
  List<List<int>> commands = [[1,2,3], [4,5,6], [7,8,9]];
  await CommandManager.sendCommandsSequentially(commands);
}
