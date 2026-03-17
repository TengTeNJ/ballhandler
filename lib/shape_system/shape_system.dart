/// 形状变换系统 - 统一导出
/// 
/// 使用示例:
/// ```dart
/// import 'package:code/shape_system/shape_system.dart';
/// 
/// // 1. 初始化仓库
/// final repo = ShapeTransformationRepository();
/// await repo.initialize();
/// 
/// // 2. 创建形状控制器
/// final controller = ShapeController();
/// 
/// // 3. 执行变换
/// final from = ShapeId(shape: BaseShape.straightLine, orientation: ShapeOrientation.normal);
/// final to = ShapeId(shape: BaseShape.straightLine, orientation: ShapeOrientation.mirrored);
/// final transform = repo.getTransformation(from, to);
/// if (transform != null) {
///   await controller.executeTransformation(transform);
/// }
/// ```

// 核心类型
export 'shape_types.dart' show 
  BaseShape, 
  BaseShapeExtension,
  ShapeOrientation, 
  ShapeOrientationExtension,
  ShapeId;

// 电机指令
export 'motor_commands.dart' show 
  MotorDirection, 
  MotorCommand, 
  DualMotorCommand, 
  TransformationSequence;

// 变换管理
export 'shape_transformation.dart' show 
  TransformPath,
  TransformPathExtension,
  ShapeTransformation, 
  ShapeTransformationRepository;

// 控制器
export 'shape_controller.dart' show 
  ShapeControlState,
  ShapeController;

// 页面（可选导入）
export 'calibration_page.dart' show 
  ShapeCalibrationPage,
  CommandEditor;

export 'preset_manager_page.dart' show 
  ShapePresetManagerPage,
  QuickCalibrationPanel;
