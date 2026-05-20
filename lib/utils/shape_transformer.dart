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
    final gameUtil = GetIt.instance<GameUtil>();
    final bluetoothManager = BluetoothManager();
    final eventBus = EventBus(); // ⚠️确保你项目里 EventBus 是单例

    for (final command in commands) {
      print('112233');

      final completer = Completer<String>();
      StreamSubscription? subscription;

      subscription = eventBus.stream.listen((reply) {
        if (reply == kReceiveControlResponse && !completer.isCompleted) {
          print('收到控制回复');
          completer.complete(reply);
        }
      });

      bluetoothManager.writerDataToDevice(
        gameUtil.selectedDeviceModel,
        command,
      );

      try {
        final reply = await completer.future
            .timeout(const Duration(seconds: 5)); // ⏱ 超时保护
        print("Processed reply: $reply");
      } catch (e) {
        print("等待设备响应超时或异常: $e");
      } finally {
        await subscription?.cancel(); // ✅ 确保释放监听
      }
    }

    print("All commands sent and received replies.");
  }

  static Future<void> sendCommands(List<int> command) async {
    final gameUtil = GetIt.instance<GameUtil>();
    final bluetoothManager = BluetoothManager();
      bluetoothManager.writerDataToDevice(
        gameUtil.selectedDeviceModel,
        command,
      );
    print("commands sent");
  }

}

void main() async {
  List<List<int>> commands = [[1,2,3], [4,5,6], [7,8,9]];
  await CommandManager.sendCommandsSequentially(commands);
}
