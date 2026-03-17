import 'dart:async';
import 'package:code/shape_system/motor_commands.dart';
import 'package:code/shape_system/shape_transformation.dart';
import 'package:code/shape_system/shape_types.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/shape_transformer.dart';
import 'package:get_it/get_it.dart';

import '../models/ble/ble_model.dart';

/// 形状控制状态
enum ShapeControlState {
  idle,       // 空闲
  moving,     // 变换中
  completed,  // 完成
  error,      // 错误
}

/// 形状控制器 - 用于执行形状变换
class ShapeController {
  final _stateController = StreamController<ShapeControlState>.broadcast();
  final _progressController = StreamController<double>.broadcast();
  final _currentShapeController = StreamController<ShapeId?>.broadcast();
  
  ShapeControlState _state = ShapeControlState.idle;
  ShapeId? _currentShape;
  
  // 流
  Stream<ShapeControlState> get stateStream => _stateController.stream;
  Stream<double> get progressStream => _progressController.stream;
  Stream<ShapeId?> get currentShapeStream => _currentShapeController.stream;
  
  // 当前状态
  ShapeControlState get state => _state;
  ShapeId? get currentShape => _currentShape;

  /// 执行单个变换
  Future<bool> executeTransformation(ShapeTransformation transformation) async {
    if (_state == ShapeControlState.moving) {
      print('正在执行变换，请等待完成');
      return false;
    }

    _setState(ShapeControlState.moving);
    _updateProgress(0);

    try {
      final commands = transformation.sequence.toBleDataList();
      final total = commands.length;
      
      for (int i = 0; i < commands.length; i++) {
        await CommandManager.sendCommandsSequentially([commands[i]]);
        _updateProgress((i + 1) / total);
      }

      _currentShape = transformation.to;
      _currentShapeController.add(_currentShape);
      _setState(ShapeControlState.completed);
      return true;
    } catch (e) {
      print('执行变换失败: $e');
      _setState(ShapeControlState.error);
      return false;
    }
  }

  /// 执行变换序列（游戏流程）
  Future<bool> executeSequence(List<ShapeTransformation> sequence) async {
    if (_state == ShapeControlState.moving) {
      print('正在执行变换，请等待完成');
      return false;
    }

    _setState(ShapeControlState.moving);

    try {
      for (int i = 0; i < sequence.length; i++) {
        final transformation = sequence[i];
        print('执行变换 ${i + 1}/${sequence.length}: ${transformation.displayName}');
        
        final success = await executeTransformation(transformation);
        if (!success) {
          _setState(ShapeControlState.error);
          return false;
        }
        
        // 变换间延迟（如果需要）
        await Future.delayed(const Duration(milliseconds: 500));
      }

      _setState(ShapeControlState.completed);
      return true;
    } catch (e) {
      print('执行序列失败: $e');
      _setState(ShapeControlState.error);
      return false;
    }
  }

  /// 快速切换到指定形状（使用预定义的变换）
  Future<bool> quickTransformTo(BaseShape targetShape, {bool mirrored = false}) async {
    if (_currentShape == null) {
      print('当前形状未知，无法快速变换');
      return false;
    }

    final target = ShapeId(shape: targetShape, orientation: mirrored ? ShapeOrientation.mirrored : ShapeOrientation.normal);
    final repository = ShapeTransformationRepository();
    
    // 先尝试直接变换
    var transformation = repository.getTransformation(_currentShape!, target);
    
    // 如果没有直接变换，尝试通过中间状态
    if (transformation == null && _currentShape!.isMirrored != mirrored) {
      // 先取消镜像/镜像
      final intermediate = ShapeId(shape: _currentShape!.shape, orientation: mirrored ? ShapeOrientation.normal : ShapeOrientation.mirrored);
      transformation = repository.getTransformation(_currentShape!, intermediate);
      if (transformation != null) {
        await executeTransformation(transformation);
        transformation = repository.getTransformation(intermediate, target);
      }
    }

    if (transformation == null) {
      print('未找到从 ${_currentShape!.displayName} 到 ${target.displayName} 的变换参数');
      return false;
    }

    return executeTransformation(transformation);
  }

  /// 发送原始电机指令（用于调试）
  Future<void> sendRawCommand(DualMotorCommand command) async {
    await CommandManager.sendCommandsSequentially([command.toBleData()]);
  }

  /// 设置当前形状（初始化用）
  void setCurrentShape(ShapeId shape) {
    _currentShape = shape;
    _currentShapeController.add(_currentShape);
  }

  /// 重置状态
  void reset() {
    _state = ShapeControlState.idle;
    _stateController.add(_state);
    _updateProgress(0);
  }

  void _setState(ShapeControlState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  void _updateProgress(double progress) {
    _progressController.add(progress);
  }

  void dispose() {
    _stateController.close();
    _progressController.close();
    _currentShapeController.close();
  }
}
