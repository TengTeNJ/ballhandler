# 形状变换系统 - 完整使用指南

## 目录

1. [快速开始](#快速开始)
2. [架构说明](#架构说明)
3. [配置变换参数](#配置变换参数)
4. [调试工具](#调试工具)
5. [在游戏页面使用](#在游戏页面使用)
6. [API 参考](#api-参考)

---

## 快速开始

### 1. 导入

```dart
import 'package:code/shape_config/shape_config.dart';
```

### 2. 基本使用

```dart
class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final ShapeCtrl _ctrl = ShapeCtrl();

  @override
  void initState() {
    super.initState();
    // 设置初始形状
    _ctrl.setShape(Shapes.straight);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // 执行单个变换
            await _ctrl.transform('straight', 'straight_mirror');
            
            // 或者执行完整游戏序列
            await _ctrl.runGameSequence();
          },
          child: Text('开始变换'),
        ),
      ),
    );
  }
}
```

---

## 架构说明

```
lib/shape_config/
├── shape_config.dart           # 统一导出
├── motor_cmd.dart              # 电机指令定义
│   ├── MotorDir                # 电机方向枚举
│   ├── MotorCmd                # 单条指令
│   └── CmdBuilder              # 链式构建器
├── shape_transforms.dart       # 变换配置库
│   ├── Shapes                  # 8种形状定义
│   ├── Transform               # 变换定义
│   └── ShapeTransforms         # 所有变换配置
├── shape_ctrl.dart             # 控制器
│   └── ShapeCtrl               # 执行控制
├── shape_debug_page.dart       # 调试页面
├── shape_manager_page.dart     # 管理页面
└── shape_game_panel.dart       # 游戏面板组件
```

---

## 配置变换参数

### 方式一：直接在代码中配置

打开 `shape_transforms.dart`，找到 `ShapeTransforms.all` 列表，添加或修改：

```dart
static const List<Transform> all = [
  // 你的变换配置
  Transform(
    from: Shapes.straight,                    // 起始形状
    to: Shapes.mirrorOf(Shapes.straight),     // 目标形状
    cmds: [
      // 电机指令列表
      MotorCmd(
        dir1: MotorDir.forward,   // 电机1方向
        time1: 100,               // 电机1时长(0-255)
        dir2: MotorDir.reversal,  // 电机2方向
        time2: 100,               // 电机2时长
        delayAfter: 200,          // 执行后延迟(ms，可选)
      ),
      // 可以有多条指令
      MotorCmd(
        dir1: MotorDir.stop,
        time1: 0,
        dir2: MotorDir.stop,
        time2: 0,
      ),
    ],
    note: '直线到镜像',  // 备注
    tag: 'mirror',      // 标签
  ),
  // ... 更多变换
];
```

### 方式二：使用链式构建器

```dart
import 'package:code/shape_config/shape_config.dart';

// 创建指令
final cmd = cmd((b) => b
  ..m1(MotorDir.forward, 100)
  ..m2(MotorDir.reversal, 100)
  ..wait(200)
);

// 或者对称运动
final cmd2 = cmd((b) => b
  ..opposite(100)  // M1正转，M2反转，都100
);

// 或者双电机同向
final cmd3 = cmd((b) => b
  ..both(MotorDir.forward, 100)
);
```

### 形状命名规则

| 形状 | 正常状态 | 镜像状态 |
|------|----------|----------|
| 直线 | `straight` | `straight_mirror` |
| 2字形 | `shape2` | `shape2_mirror` |
| L形 | `l_shape` | `l_shape_mirror` |
| Ω形 | `omega` | `omega_mirror` |
| 五边形 | `pentagon` | `pentagon_mirror` |
| 微笑形 | `smile` | `smile_mirror` |
| Z字形 | `zigzag` | `zigzag_mirror` |
| 猫形 | `cat` | `cat_mirror` |

---

## 调试工具

### 调试页面

```dart
// 导航到调试页面
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => ShapeDebugPage()),
);
```

调试页面功能：
- 电机方向和时长滑块
- 实时发送指令测试
- 构建指令序列
- 复制生成的代码
- 测试预设变换
- 测试完整游戏序列

### 管理页面

```dart
// 查看所有变换
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => ShapeManagerPage()),
);
```

管理页面功能：
- 查看所有变换配置
- 按形状筛选
- 按标签筛选
- 检查配置完整性
- 导出完整配置代码
- 统计信息

### 调试工作流程

```
1. 运行调试页面
   ↓
2. 调整滑块找到正确参数
   ↓
3. 点击"加入序列"
   ↓
4. 重复直到完整变换
   ↓
5. 点击"复制代码"
   ↓
6. 粘贴到 shape_transforms.dart
   ↓
7. 热重载测试
```

---

## 在游戏页面使用

### 方式一：使用游戏面板组件

```dart
class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 游戏内容
          Expanded(child: GameContent()),
          
          // 形状控制面板
          ShapeGamePanel(
            onOpenDebug: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ShapeDebugPage()),
              );
            },
          ),
        ],
      ),
      // 悬浮调试按钮
      floatingActionButton: ShapeDebugFab(),
    );
  }
}
```

### 方式二：自定义集成

```dart
class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final ShapeCtrl _ctrl = ShapeCtrl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 当前形状显示
          StreamBuilder<String?>(
            stream: _ctrl.shapeStream,
            builder: (context, snap) {
              final shape = snap.data ?? '未知';
              return Text('当前: ${Shapes.getName(shape)}');
            },
          ),

          // 进度条
          StreamBuilder<double>(
            stream: _ctrl.progressStream,
            builder: (context, snap) {
              return LinearProgressIndicator(value: snap.data);
            },
          ),

          // 状态显示
          StreamBuilder<CtrlState>(
            stream: _ctrl.stateStream,
            builder: (context, snap) {
              return Text('状态: ${snap.data?.name ?? "idle"}');
            },
          ),

          // 控制按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _ctrl.runGameSequence(),
                child: Text('开始游戏'),
              ),
              ElevatedButton(
                onPressed: () => _ctrl.toggleMirror(),
                child: Text('镜像切换'),
              ),
              ElevatedButton(
                onPressed: () => _ctrl.stop(),
                child: Text('停止'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## API 参考

### ShapeCtrl 控制器

| 方法 | 说明 | 示例 |
|------|------|------|
| `setShape(shape)` | 设置当前形状 | `ctrl.setShape('straight')` |
| `transform(from, to)` | 执行单个变换 | `ctrl.transform('a', 'b')` |
| `runSequence(list)` | 执行序列 | `ctrl.runSequence([...])` |
| `runGameSequence()` | 执行游戏序列 | `ctrl.runGameSequence()` |
| `quickTo(target)` | 快速变换 | `ctrl.quickTo('l_shape')` |
| `toggleMirror()` | 镜像切换 | `ctrl.toggleMirror()` |
| `sendRaw(cmd)` | 发送原始指令 | `ctrl.sendRaw(cmd)` |
| `stop()` | 停止 | `ctrl.stop()` |
| `reset()` | 重置 | `ctrl.reset()` |

### ShapeTransforms 查询

| 方法 | 说明 | 示例 |
|------|------|------|
| `find(from, to)` | 查找变换 | `ShapeTransforms.find('a', 'b')` |
| `getGameSequence()` | 获取游戏序列 | `ShapeTransforms.getGameSequence()` |
| `getForShape(s)` | 获取形状相关 | `ShapeTransforms.getForShape('straight')` |
| `getMissingTransforms()` | 获取缺失配置 | `ShapeTransforms.getMissingTransforms()` |
| `generateConfigCode()` | 生成配置代码 | `ShapeTransforms.generateConfigCode()` |

### Shapes 工具

| 方法 | 说明 | 示例 |
|------|------|------|
| `mirrorOf(shape)` | 获取镜像 | `Shapes.mirrorOf('straight')` |
| `isMirror(shape)` | 是否镜像 | `Shapes.isMirror('straight_mirror')` |
| `baseOf(shape)` | 获取基础形状 | `Shapes.baseOf('straight_mirror')` |
| `toggleMirror(shape)` | 切换镜像 | `Shapes.toggleMirror('straight')` |
| `getName(shape)` | 获取显示名 | `Shapes.getName('straight')` |

---

## 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:code/shape_config/shape_config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShapeDemoPage(),
    );
  }
}

class ShapeDemoPage extends StatefulWidget {
  @override
  _ShapeDemoPageState createState() => _ShapeDemoPageState();
}

class _ShapeDemoPageState extends State<ShapeDemoPage> {
  final ShapeCtrl _ctrl = ShapeCtrl();

  @override
  void initState() {
    super.initState();
    _ctrl.setShape(Shapes.straight);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('形状变换演示')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 状态显示
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    StreamBuilder<String?>(
                      stream: _ctrl.shapeStream,
                      builder: (context, snap) {
                        return Text(
                          '当前: ${Shapes.getName(snap.data ?? '未知')}',
                          style: TextStyle(fontSize: 24),
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    StreamBuilder<CtrlState>(
                      stream: _ctrl.stateStream,
                      builder: (context, snap) {
                        return Text('状态: ${snap.data?.name ?? 'idle'}');
                      },
                    ),
                    SizedBox(height: 8),
                    StreamBuilder<double>(
                      stream: _ctrl.progressStream,
                      builder: (context, snap) {
                        return LinearProgressIndicator(
                          value: snap.data ?? 0,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // 控制按钮
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _ctrl.runGameSequence(),
                  child: Text('完整游戏序列'),
                ),
                ElevatedButton(
                  onPressed: () => _ctrl.toggleMirror(),
                  child: Text('镜像切换'),
                ),
                ElevatedButton(
                  onPressed: () => _ctrl.stop(),
                  child: Text('停止'),
                ),
              ],
            ),

            SizedBox(height: 16),

            // 形状选择
            Text('快速变换:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: Shapes.all.expand((shape) => [
                ActionChip(
                  label: Text(Shapes.names[shape]!),
                  onPressed: () => _ctrl.quickTo(shape),
                ),
                ActionChip(
                  label: Text('${Shapes.names[shape]}镜'),
                  onPressed: () => _ctrl.quickTo(Shapes.mirrorOf(shape)),
                ),
              ]).toList(),
            ),

            SizedBox(height: 16),

            // 调试入口
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ShapeDebugPage()),
                );
              },
              icon: Icon(Icons.build),
              label: Text('打开调试工具'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 注意事项

1. **时长单位**: `time1` 和 `time2` 是 0-255 的整数，实际时间取决于硬件（通常是 10ms 或 100ms 一个单位）

2. **指令延迟**: 如果一条指令执行完后需要等待电机到位，使用 `delayAfter` 参数

3. **状态监听**: 变换是异步的，使用 Stream 监听状态变化

4. **错误处理**: `transform` 和 `runSequence` 返回 `Future<bool>`，失败时返回 false

5. **资源释放**: 页面销毁时记得调用 `_ctrl.dispose()`
