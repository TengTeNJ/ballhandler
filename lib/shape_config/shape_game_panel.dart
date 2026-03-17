import 'package:code/shape_config/motor_cmd.dart';
import 'package:code/shape_config/shape_ctrl.dart';
import 'package:code/shape_config/shape_transforms.dart';
import 'package:flutter/material.dart';

/// 游戏控制面板 - 可在游戏页面嵌入
class ShapeGamePanel extends StatefulWidget {
  final VoidCallback? onOpenDebug;
  
  const ShapeGamePanel({super.key, this.onOpenDebug});

  @override
  State<ShapeGamePanel> createState() => _ShapeGamePanelState();
}

class _ShapeGamePanelState extends State<ShapeGamePanel> {
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
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 当前形状显示
            StreamBuilder<String?>(
              stream: _ctrl.shapeStream,
              builder: (context, snap) {
                final shape = snap.data ?? _ctrl.currentShape ?? '未设置';
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    Shapes.getName(shape),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // 进度条
            StreamBuilder<double>(
              stream: _ctrl.progressStream,
              builder: (context, snap) {
                final progress = snap.data ?? 0;
                return Column(
                  children: [
                    LinearProgressIndicator(value: progress > 0 ? progress : null),
                    if (progress > 0)
                      Text('${(progress * 100).toInt()}%'),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // 控制按钮
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _btn('开始游戏', Icons.play_arrow, Colors.green, _startGame),
                _btn('镜像切换', Icons.flip, Colors.blue, _ctrl.toggleMirror),
                _btn('停止', Icons.stop, Colors.red, _ctrl.stop),
                _btn('调试', Icons.build, Colors.orange, widget.onOpenDebug),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 快速形状选择
            const Text('快速变换到:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: Shapes.all.expand((shape) => [
                _shapeChip(shape, false),
                _shapeChip(shape, true),
              ]).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(String text, IconData icon, Color color, VoidCallback? onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _shapeChip(String shape, bool mirror) {
    final fullShape = mirror ? Shapes.mirrorOf(shape) : shape;
    final label = mirror ? '${Shapes.names[shape]}镜' : Shapes.names[shape];
    
    return ActionChip(
      label: Text(label ?? fullShape, style: const TextStyle(fontSize: 12)),
      onPressed: () => _ctrl.quickTo(fullShape),
    );
  }

  Future<void> _startGame() async {
    await _ctrl.runGameSequence();
  }
}

/// 悬浮调试按钮
class ShapeDebugFab extends StatelessWidget {
  const ShapeDebugFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => const ShapeQuickDebugPanel(),
        );
      },
      child: const Icon(Icons.build),
    );
  }
}

/// 快速调试面板
class ShapeQuickDebugPanel extends StatelessWidget {
  const ShapeQuickDebugPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('快速调试', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          // 常用操作
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _actionBtn(context, '复位', Icons.restore, () {}),
              _actionBtn(context, '直线', Icons.horizontal_rule, () {}),
              _actionBtn(context, '测试序列', Icons.playlist_play, () {}),
              _actionBtn(context, '完整调试', Icons.open_in_new, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Placeholder()),
                );
              }),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 形状选择
          const Text('选择形状', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              for (final shape in Shapes.all) ...[
                ChoiceChip(
                  label: Text(Shapes.names[shape] ?? shape),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(text),
    );
  }
}
