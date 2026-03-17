import 'package:code/utils/ble_razor_data.dart';
import 'package:code/utils/ble_razor_service_data.dart';

/// 电机方向枚举
enum MotorDirection {
  stop,      // 停止
  forward,   // 正转
  reversal,  // 反转
}

/// 单个电机的指令
class MotorCommand {
  final MotorDirection direction;
  final int duration; // 0-255，单位根据硬件决定（通常是10ms或100ms）

  const MotorCommand({
    required this.direction,
    required this.duration,
  });

  /// 转换为蓝牙协议需要的格式
  BleRazorMotorStatu get bleStatus {
    switch (direction) {
      case MotorDirection.stop:
        return BleRazorMotorStatu.stop;
      case MotorDirection.forward:
        return BleRazorMotorStatu.forward;
      case MotorDirection.reversal:
        return BleRazorMotorStatu.reversal;
    }
  }

  /// 转换为蓝牙数据包
  List<int> toBleData() {
    return [bleStatus.index, duration];
  }

  MotorCommand copyWith({
    MotorDirection? direction,
    int? duration,
  }) {
    return MotorCommand(
      direction: direction ?? this.direction,
      duration: duration ?? this.duration,
    );
  }

  @override
  String toString() => 'MotorCommand(direction: $direction, duration: $duration)';
}

/// 双电机指令（一条完整的控制指令）
class DualMotorCommand {
  final MotorCommand motor1;
  final MotorCommand motor2;

  const DualMotorCommand({
    required this.motor1,
    required this.motor2,
  });

  /// 转换为蓝牙协议数据
  List<int> toBleData() {
    return motorControlData(
      motorStatus: [motor1.bleStatus, motor2.bleStatus],
      timers: [motor1.duration, motor2.duration],
    );
  }

  DualMotorCommand copyWith({
    MotorCommand? motor1,
    MotorCommand? motor2,
  }) {
    return DualMotorCommand(
      motor1: motor1 ?? this.motor1,
      motor2: motor2 ?? this.motor2,
    );
  }

  @override
  String toString() => 'DualMotorCommand(motor1: $motor1, motor2: $motor2)';
}

/// 变换序列（从形状A到形状B可能需要多条指令）
class TransformationSequence {
  final String name; // 变换名称，如 "ShapeA_to_ShapeA_Mirror"
  final List<DualMotorCommand> commands;
  final String? description;

  const TransformationSequence({
    required this.name,
    required this.commands,
    this.description,
  });

  /// 获取所有蓝牙数据包
  List<List<int>> toBleDataList() {
    return commands.map((cmd) => cmd.toBleData()).toList();
  }

  TransformationSequence copyWith({
    String? name,
    List<DualMotorCommand>? commands,
    String? description,
  }) {
    return TransformationSequence(
      name: name ?? this.name,
      commands: commands ?? this.commands,
      description: description ?? this.description,
    );
  }

  @override
  String toString() => 'TransformationSequence(name: $name, commands: ${commands.length})';
}
