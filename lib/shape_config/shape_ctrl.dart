import 'dart:async';
import 'package:code/shape_config/motor_cmd.dart';
import 'package:code/shape_config/shape_transforms.dart';
import 'package:code/utils/shape_transformer.dart';

/// 控制器状态
enum CtrlState { idle, running, paused, error }

/// 形状控制器
class ShapeCtrl {
  String? _currentShape;
  CtrlState _state = CtrlState.idle;
  int _currentStep = 0;
  List<Transform> _runningSequence = [];
  
  final _shapeCtrl = StreamController<String?>.broadcast();
  final _stateCtrl = StreamController<CtrlState>.broadcast();
  final _progressCtrl = StreamController<double>.broadcast();
  final _stepCtrl = StreamController<int>.broadcast();
  
  // Getters
  String? get currentShape => _currentShape;
  CtrlState get state => _state;
  int get currentStep => _currentStep;
  List<Transform> get runningSequence => List.unmodifiable(_runningSequence);
  bool get isRunning => _state == CtrlState.running;
  bool get isIdle => _state == CtrlState.idle;

  // Streams
  Stream<String?> get shapeStream => _shapeCtrl.stream;
  Stream<CtrlState> get stateStream => _stateCtrl.stream;
  Stream<double> get progressStream => _progressCtrl.stream;
  Stream<int> get stepStream => _stepCtrl.stream;

  /// 设置当前形状
  void setShape(String shape) {
    _currentShape = shape;
    _shapeCtrl.add(shape);
  }

  /// 执行单个变换
  Future<bool> transform(String from, String to, {bool updateState = true}) async {
    if (_state == CtrlState.running && updateState) {
      print('⚠️ 正在执行中...');
      return false;
    }

    final t = ShapeTransforms.find(from, to);
    if (t == null) {
      print('❌ 未找到变换: $from → $to');
      _setState(CtrlState.error);
      return false;
    }

    if (updateState) {
      _setState(CtrlState.running);
    }

    print('🔄 ${t.displayName}');
    
    for (int i = 0; i < t.cmds.length; i++) {
      final cmd = t.cmds[i];
      print('   [${i + 1}/${t.cmds.length}] $cmd');
      
      await CommandManager.sendCommandsSequentially([cmd.toBleData()]);
      
      // 等待执行完成
      final waitTime = (cmd.time1 + cmd.time2) * 10 + 100;
      await Future.delayed(Duration(milliseconds: waitTime));
      
      // 额外延迟
      if (cmd.delayAfter != null) {
        await Future.delayed(Duration(milliseconds: cmd.delayAfter!));
      }
    }

    if (updateState) {
      _currentShape = to;
      _shapeCtrl.add(to);
      _setState(CtrlState.idle);
    }
    
    print('✅ 完成: ${Shapes.getName(to)}');
    return true;
  }

  /// 执行变换序列
  Future<bool> runSequence(List<Transform> sequence, {int delayBetween = 500}) async {
    if (_state == CtrlState.running) {
      print('⚠️ 已有序列在执行中');
      return false;
    }

    _runningSequence = List.from(sequence);
    _currentStep = 0;
    _setState(CtrlState.running);

    print('▶️ 开始序列 (${sequence.length}步)');

    for (int i = 0; i < sequence.length; i++) {
      if (_state != CtrlState.running) {
        print('⏹️ 序列被中断');
        return false;
      }

      _currentStep = i + 1;
      _stepCtrl.add(_currentStep);
      _updateProgress(i / sequence.length);

      final t = sequence[i];
      final ok = await transform(t.from, t.to, updateState: false);
      
      if (!ok) {
        _setState(CtrlState.error);
        return false;
      }

      // 步骤间延迟
      if (i < sequence.length - 1) {
        await Future.delayed(Duration(milliseconds: delayBetween));
      }
    }

    _currentShape = sequence.last.to;
    _shapeCtrl.add(_currentShape);
    _updateProgress(1);
    _setState(CtrlState.idle);
    
    print('✅ 序列完成');
    return true;
  }

  /// 执行游戏完整序列
  Future<bool> runGameSequence({String? startFrom}) async {
    final sequence = startFrom != null 
        ? ShapeTransforms.getSequenceFrom(startFrom)
        : ShapeTransforms.getGameSequence();
    return runSequence(sequence);
  }

  /// 快速变换到目标形状（自动找最短路径）
  Future<bool> quickTo(String targetShape) async {
    if (_currentShape == null) {
      print('❌ 当前形状未知，先调用 setShape()');
      return false;
    }

    if (_currentShape == targetShape) {
      print('✓ 已经在目标形状');
      return true;
    }

    // 直接变换
    if (await transform(_currentShape!, targetShape)) {
      return true;
    }

    // 尝试通过中间状态
    final currentBase = Shapes.baseOf(_currentShape!);
    final targetBase = Shapes.baseOf(targetShape);
    final currentIsMirror = Shapes.isMirror(_currentShape!);
    final targetIsMirror = Shapes.isMirror(targetShape);

    // 如果是同形状，先取消/添加镜像
    if (currentBase == targetBase) {
      final intermediate = currentIsMirror 
          ? currentBase 
          : Shapes.mirrorOf(currentBase);
      
      if (await transform(_currentShape!, intermediate)) {
        return await transform(intermediate, targetShape);
      }
    }

    // 尝试：当前 → 当前正常 → 目标正常 → 目标
    final currentNormal = currentIsMirror ? currentBase : _currentShape!;
    final targetNormal = targetIsMirror ? targetBase : targetShape;

    if (currentIsMirror) {
      if (!await transform(_currentShape!, currentNormal)) return false;
    }
    
    if (await transform(currentNormal, targetNormal)) {
      if (targetIsMirror) {
        return await transform(targetNormal, targetShape);
      }
      return true;
    }

    print('❌ 无法找到路径: $_currentShape → $targetShape');
    return false;
  }

  /// 镜像当前形状
  Future<bool> toggleMirror() async {
    if (_currentShape == null) return false;
    final target = Shapes.toggleMirror(_currentShape!);
    return await quickTo(target);
  }

  /// 发送原始指令（调试用）
  Future<void> sendRaw(MotorCmd cmd) async {
    await CommandManager.sendCommandsSequentially([cmd.toBleData()]);
  }

  /// 发送多条原始指令
  Future<void> sendRawList(List<MotorCmd> cmds) async {
    for (final cmd in cmds) {
      await sendRaw(cmd);
      await Future.delayed(Duration(milliseconds: 200));
    }
  }

  /// 停止当前操作
  void stop() {
    if (_state == CtrlState.running) {
      _setState(CtrlState.idle);
      print('⏹️ 已停止');
    }
  }

  /// 暂停（可恢复）
  void pause() {
    if (_state == CtrlState.running) {
      _setState(CtrlState.paused);
      print('⏸️ 已暂停');
    }
  }

  /// 恢复
  void resume() {
    if (_state == CtrlState.paused) {
      _setState(CtrlState.running);
      print('▶️ 已恢复');
    }
  }

  /// 重置
  void reset() {
    stop();
    _currentStep = 0;
    _runningSequence = [];
    _updateProgress(0);
  }

  void _setState(CtrlState s) {
    _state = s;
    _stateCtrl.add(s);
  }

  void _updateProgress(double p) {
    _progressCtrl.add(p);
  }

  void dispose() {
    _shapeCtrl.close();
    _stateCtrl.close();
    _progressCtrl.close();
    _stepCtrl.close();
  }
}
