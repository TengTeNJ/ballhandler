import 'package:code/utils/ble_razor_data.dart';
import 'package:code/utils/ble_razor_service_data.dart';

/// 电机方向
enum MotorDir { stop, forward, reversal }

extension MotorDirExt on MotorDir {
  BleRazorMotorStatu get bleStatus {
    switch (this) {
      case MotorDir.stop: return BleRazorMotorStatu.stop;
      case MotorDir.forward: return BleRazorMotorStatu.forward;
      case MotorDir.reversal: return BleRazorMotorStatu.reversal;
    }
  }

  String get displayName {
    switch (this) {
      case MotorDir.stop: return '停止';
      case MotorDir.forward: return '正转';
      case MotorDir.reversal: return '反转';
    }
  }

  String get shortName {
    switch (this) {
      case MotorDir.stop: return '○';
      case MotorDir.forward: return '→';
      case MotorDir.reversal: return '←';
    }
  }
}

/// 单条电机指令
class MotorCmd {
  final MotorDir dir1;
  final int time1;  // 0-255
  final MotorDir dir2;
  final int time2;  // 0-255
  final int? delayAfter; // 执行完后的延迟(ms)

  const MotorCmd({
    required this.dir1,
    required this.time1,
    required this.dir2,
    required this.time2,
    this.delayAfter,
  });

  /// 转换为蓝牙数据
  List<int> toBleData() {
    return motorControlData(
      motorStatus: [dir1.bleStatus, dir2.bleStatus],
      timers: [time1, time2],
    );
  }

  /// 复制并修改
  MotorCmd copyWith({
    MotorDir? dir1,
    int? time1,
    MotorDir? dir2,
    int? time2,
    int? delayAfter,
  }) {
    return MotorCmd(
      dir1: dir1 ?? this.dir1,
      time1: time1 ?? this.time1,
      dir2: dir2 ?? this.dir2,
      time2: time2 ?? this.time2,
      delayAfter: delayAfter ?? this.delayAfter,
    );
  }

  @override
  String toString() => 'MotorCmd(M1:${dir1.shortName}$time1, M2:${dir2.shortName}$time2)';

  /// 生成Dart代码
  String toCodeString() {
    final buffer = StringBuffer();
    buffer.write('const MotorCmd(');
    buffer.write('dir1: MotorDir.${dir1.name}, time1: $time1, ');
    buffer.write('dir2: MotorDir.${dir2.name}, time2: $time2');
    if (delayAfter != null) {
      buffer.write(', delayAfter: $delayAfter');
    }
    buffer.write(')');
    return buffer.toString();
  }
}

/// 指令构建器 - 链式调用
class CmdBuilder {
  MotorDir _dir1 = MotorDir.stop;
  int _time1 = 0;
  MotorDir _dir2 = MotorDir.stop;
  int _time2 = 0;
  int? _delayAfter;

  CmdBuilder m1(MotorDir dir, int time) {
    _dir1 = dir;
    _time1 = time;
    return this;
  }

  CmdBuilder m2(MotorDir dir, int time) {
    _dir2 = dir;
    _time2 = time;
    return this;
  }

  CmdBuilder both(MotorDir dir, int time) {
    _dir1 = dir;
    _time1 = time;
    _dir2 = dir;
    _time2 = time;
    return this;
  }

  CmdBuilder opposite(int time) {
    _dir1 = MotorDir.forward;
    _time1 = time;
    _dir2 = MotorDir.reversal;
    _time2 = time;
    return this;
  }

  CmdBuilder wait(int ms) {
    _delayAfter = ms;
    return this;
  }

  MotorCmd build() {
    return MotorCmd(
      dir1: _dir1,
      time1: _time1,
      dir2: _dir2,
      time2: _time2,
      delayAfter: _delayAfter,
    );
  }
}

/// 快捷构建方法
MotorCmd cmd([void Function(CmdBuilder)? build]) {
  final builder = CmdBuilder();
  if (build != null) build(builder);
  return builder.build();
}
