/// 形状变换配置系统
/// 
/// 完整导出，按需导入
/// 
/// 基础使用:
/// ```dart
/// import 'package:code/shape_config/shape_config.dart';
/// 
/// // 控制器
/// final ctrl = ShapeCtrl();
/// ctrl.setShape('straight');
/// 
/// // 执行变换
/// await ctrl.transform('straight', 'straight_mirror');
/// 
/// // 完整游戏序列
/// await ctrl.runGameSequence();
/// ```

// 核心类型
export 'motor_cmd.dart' show 
  MotorDir, 
  MotorDirExt,
  MotorCmd,
  CmdBuilder,
  cmd;

// 形状定义和变换配置
export 'shape_transforms.dart' show 
  Shapes, 
  Transform,
  ShapeTransforms;

// 控制器
export 'shape_ctrl.dart' show 
  CtrlState,
  ShapeCtrl;

// 页面
export 'shape_debug_page.dart' show ShapeDebugPage;
export 'shape_manager_page.dart' show ShapeManagerPage;
export 'shape_game_panel.dart' show 
  ShapeGamePanel,
  ShapeDebugFab,
  ShapeQuickDebugPanel;
