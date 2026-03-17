# 形状变换系统使用指南

## 架构概览

```
┌─────────────────────────────────────────────────────────────┐
│                        应用层                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   游戏页面    │  │  调试页面     │  │  预设管理     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
├─────────────────────────────────────────────────────────────┤
│                      ShapeController                         │
│                   (状态管理 + 执行控制)                       │
├─────────────────────────────────────────────────────────────┤
│                ShapeTransformationRepository                 │
│                   (数据持久化 + 查询)                         │
├─────────────────────────────────────────────────────────────┤
│  ShapeTransformation + MotorCommand + ShapeId               │
│                   (数据模型层)                               │
├─────────────────────────────────────────────────────────────┤
│              CommandManager (原有蓝牙通信)                    │
└─────────────────────────────────────────────────────────────┘
```

## 快速开始

### 1. 在 main.dart 中初始化

```dart
import 'package:code/shape_system/shape_system.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化形状变换仓库
  await ShapeTransformationRepository().initialize();
  
  runApp(MyApp());
}
```

### 2. 在游戏页面中使用

```dart
import 'package:code/shape_system/shape_system.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final ShapeController _controller = ShapeController();
  
  @override
  void initState() {
    super.initState();
    // 设置初始形状
    _controller.setCurrentShape(
      ShapeId(shape: BaseShape.straightLine, orientation: ShapeOrientation.normal)
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  // 执行形状变换
  Future<void> transformShape() async {
    final repository = ShapeTransformationRepository();
    
    final from = ShapeId(
      shape: BaseShape.straightLine, 
      orientation: ShapeOrientation.normal
    );
    final to = ShapeId(
      shape: BaseShape.straightLine, 
      orientation: ShapeOrientation.mirrored
    );
    
    final transformation = repository.getTransformation(from, to);
    if (transformation != null) {
      final success = await _controller.executeTransformation(transformation);
      if (success) {
        print('变换成功！');
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 监听变换状态
          StreamBuilder<ShapeControlState>(
            stream: _controller.stateStream,
            builder: (context, snapshot) {
              final state = snapshot.data ?? ShapeControlState.idle;
              return Text('状态: $state');
            },
          ),
          
          // 监听进度
          StreamBuilder<double>(
            stream: _controller.progressStream,
            builder: (context, snapshot) {
              final progress = snapshot.data ?? 0;
              return LinearProgressIndicator(value: progress);
            },
          ),
          
          ElevatedButton(
            onPressed: transformShape,
            child: Text('执行变换'),
          ),
        ],
      ),
    );
  }
}
```

### 3. 游戏流程示例（8种形状变换）

```dart
// 定义游戏流程
final gameShapes = [
  BaseShape.straightLine,
  BaseShape.shape2,
  BaseShape.lShape,
  BaseShape.omega,
  BaseShape.pentagon,
  BaseShape.smile,
  BaseShape.zigzag,
  BaseShape.cat,
];

// 获取完整的变换序列
Future<void> startGameSequence() async {
  final repository = ShapeTransformationRepository();
  final sequence = repository.getGameSequence(gameShapes);
  
  // 检查是否所有变换都已配置
  final missing = sequence.where((t) => t.sequence.commands.isEmpty).toList();
  if (missing.isNotEmpty) {
    print('以下变换尚未配置: ${missing.map((m) => m.displayName).join(', ')}');
    return;
  }
  
  // 执行序列
  final success = await _controller.executeSequence(sequence);
  if (success) {
    print('游戏流程完成！');
  }
}
```

## 调试工作流

### 第一步：打开预设管理页面生成结构

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => ShapePresetManagerPage()),
);
```

点击右上角菜单 → "生成默认结构"

这会生成所有需要的变换模板（正常→镜像，镜像→正常，以及形状间的变换）。

### 第二步：逐个调试变换参数

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => ShapeCalibrationPage()),
);
```

调试流程：
1. 选择起始形状和目标形状
2. 添加电机指令（可以添加多条）
3. 点击"测试"发送指令观察效果
4. 调整参数直到形状变换正确
5. 点击"保存"

### 第三步：在游戏页面添加快速调试入口

```dart
// 在角落添加悬浮调试按钮
floatingActionButton: FloatingActionButton(
  mini: true,
  onPressed: () {
    showModalBottomSheet(
      context: context,
      builder: (_) => QuickCalibrationPanel(
        onOpenFullCalibration: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ShapeCalibrationPage()),
          );
        },
      ),
    );
  },
  child: Icon(Icons.build),
),
```

## 数据备份与分享

### 导出所有参数

在 `ShapePresetManagerPage` 中点击"导出全部"，参数会复制到剪贴板。

或者代码中：
```dart
final data = ShapeTransformationRepository().exportAll();
final jsonStr = jsonEncode(data);
// 保存到文件或上传服务器
```

### 导入参数

在 `ShapePresetManagerPage` 中点击"导入"，从剪贴板读取。

或者代码中：
```dart
final jsonStr = await loadFromFile(); // 从文件加载
final data = jsonDecode(jsonStr);
await ShapeTransformationRepository().importAll(data);
```

## 关键类说明

### ShapeId
标识一个具体的形状状态（形状类型 + 是否镜像）

```dart
final shape = ShapeId(
  shape: BaseShape.straightLine,
  orientation: ShapeOrientation.normal, // 或 mirrored
);
```

### ShapeTransformation
定义从一个形状到另一个形状的变换

```dart
final transform = ShapeTransformation(
  from: ShapeId(shape: BaseShape.straightLine, orientation: ShapeOrientation.normal),
  to: ShapeId(shape: BaseShape.straightLine, orientation: ShapeOrientation.mirrored),
  sequence: TransformationSequence(
    name: '直线到镜像',
    commands: [
      DualMotorCommand(
        motor1: MotorCommand(direction: MotorDirection.forward, duration: 100),
        motor2: MotorCommand(direction: MotorDirection.reversal, duration: 100),
      ),
    ],
  ),
);
```

### MotorCommand
单个电机的指令

```dart
MotorCommand(
  direction: MotorDirection.forward, // forward, reversal, stop
  duration: 100, // 0-255
)
```

### DualMotorCommand
双电机指令（一条完整的蓝牙指令）

```dart
DualMotorCommand(
  motor1: MotorCommand(direction: MotorDirection.forward, duration: 100),
  motor2: MotorCommand(direction: MotorDirection.reversal, duration: 100),
)
```

## 文件结构

```
lib/shape_system/
├── shape_system.dart           # 统一导出
├── shape_types.dart            # 形状类型定义
├── motor_commands.dart         # 电机指令定义
├── shape_transformation.dart   # 变换管理和存储
├── shape_controller.dart       # 控制器（执行变换）
├── calibration_page.dart       # 调试页面
└── preset_manager_page.dart    # 预设管理页面
```

## 依赖

需要在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  shared_preferences: ^2.2.0
```

## 进阶用法

### 自定义变换序列

```dart
// 创建自定义的变换序列
final customSequence = [
  // 直线 -> 直线镜像
  repo.getTransformation(
    ShapeId(shape: BaseShape.straightLine, orientation: ShapeOrientation.normal),
    ShapeId(shape: BaseShape.straightLine, orientation: ShapeOrientation.mirrored),
  ),
  // 直线镜像 -> L形
  repo.getTransformation(
    ShapeId(shape: BaseShape.straightLine, orientation: ShapeOrientation.mirrored),
    ShapeId(shape: BaseShape.lShape, orientation: ShapeOrientation.normal),
  ),
  // 更多...
].whereType<ShapeTransformation>().toList();

await controller.executeSequence(customSequence);
```

### 监听当前形状变化

```dart
StreamBuilder<ShapeId?>(
  stream: controller.currentShapeStream,
  builder: (context, snapshot) {
    final current = snapshot.data;
    if (current == null) return Text('未知形状');
    return Text('当前: ${current.displayName}');
  },
),
```

### 批量修改参数

```dart
// 获取某形状的所有变换
final transforms = repo.getTransformationsForShape(BaseShape.straightLine);

// 批量修改（例如统一调整时长）
for (final t in transforms) {
  final newCommands = t.sequence.commands.map((cmd) {
    return cmd.copyWith(
      motor1: cmd.motor1.copyWith(duration: cmd.motor1.duration + 10),
      motor2: cmd.motor2.copyWith(duration: cmd.motor2.duration + 10),
    );
  }).toList();
  
  await repo.saveTransformation(t.copyWith(
    sequence: t.sequence.copyWith(commands: newCommands),
  ));
}
```
