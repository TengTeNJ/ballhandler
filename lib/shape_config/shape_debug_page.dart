import 'package:code/shape_config/motor_cmd.dart';
import 'package:code/shape_config/shape_ctrl.dart';
import 'package:code/shape_config/shape_transforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 形状调试页面
class ShapeDebugPage extends StatefulWidget {
  const ShapeDebugPage({super.key});

  @override
  State<ShapeDebugPage> createState() => _ShapeDebugPageState();
}

class _ShapeDebugPageState extends State<ShapeDebugPage> {
  final ShapeCtrl _ctrl = ShapeCtrl();
  
  // 当前编辑的指令
  MotorDir _dir1 = MotorDir.stop;
  int _time1 = 100;
  MotorDir _dir2 = MotorDir.stop;
  int _time2 = 100;
  int? _delayAfter;

  // 指令序列
  final List<MotorCmd> _sequence = [];
  
  // 选中的变换
  Transform? _selectedTransform;

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
      appBar: AppBar(
        title: const Text('形状变换调试'),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_play),
            onPressed: _showTransformList,
          ),
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: _showGeneratedCode,
          ),
        ],
      ),
      body: Column(
        children: [
          // 状态显示
          _buildStatusBar(),
          
          // 电机控制
          Expanded(
            flex: 2,
            child: _buildControlPanel(),
          ),
          
          // 快捷测试
          _buildQuickTests(),
          
          // 当前序列
          Expanded(
            flex: 2,
            child: _buildSequenceList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.blue[50],
      child: Row(
        children: [
          StreamBuilder<String?>(
            stream: _ctrl.shapeStream,
            builder: (context, snap) {
              final shape = snap.data ?? _ctrl.currentShape ?? '未设置';
              return Text(
                '当前: ${Shapes.getName(shape)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
            },
          ),
          const Spacer(),
          StreamBuilder<CtrlState>(
            stream: _ctrl.stateStream,
            builder: (context, snap) {
              final state = snap.data ?? CtrlState.idle;
              final color = state == CtrlState.running 
                  ? Colors.orange 
                  : state == CtrlState.error 
                      ? Colors.red 
                      : Colors.green;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  state.name.toUpperCase(),
                  style: TextStyle(color: color, fontSize: 12),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMotorControl('电机1', _dir1, _time1, (d, t) => setState(() {
            _dir1 = d;
            _time1 = t;
          })),
          const SizedBox(height: 16),
          _buildMotorControl('电机2', _dir2, _time2, (d, t) => setState(() {
            _dir2 = d;
            _time2 = t;
          })),
          const SizedBox(height: 16),
          
          // 延迟设置
          Row(
            children: [
              const Text('执行后延迟:'),
              Expanded(
                child: Slider(
                  value: (_delayAfter ?? 0).toDouble(),
                  min: 0,
                  max: 1000,
                  divisions: 20,
                  label: '${_delayAfter ?? 0}ms',
                  onChanged: (v) => setState(() => _delayAfter = v > 0 ? v.toInt() : null),
                ),
              ),
              Text('${_delayAfter ?? 0}ms'),
            ],
          ),
          
          // 操作按钮
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _sendCommand,
                  icon: const Icon(Icons.send),
                  label: const Text('发送'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _addToSequence,
                icon: const Icon(Icons.add),
                label: const Text('加入序列'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _sequence.isNotEmpty ? _sendSequence : null,
                icon: const Icon(Icons.play_arrow),
                label: Text('发送序列(${_sequence.length})'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMotorControl(String label, MotorDir dir, int time, Function(MotorDir, int) onChanged) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SegmentedButton<MotorDir>(
            segments: MotorDir.values.map((d) => 
              ButtonSegment(
                value: d, 
                label: Text(d.shortName),
                tooltip: d.displayName,
              )
            ).toList(),
            selected: {dir},
            onSelectionChanged: (set) {
              if (set.isNotEmpty) onChanged(set.first, time);
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('时长:'),
              Expanded(
                child: Slider(
                  value: time.toDouble(),
                  min: 0,
                  max: 255,
                  divisions: 255,
                  label: time.toString(),
                  onChanged: (v) => onChanged(dir, v.toInt()),
                ),
              ),
              Container(
                width: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$time',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTests() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('快速测试', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _quickBtn('直线→镜像', () => _testTransform('straight', 'straight_mirror')),
                _quickBtn('镜像→直线', () => _testTransform('straight_mirror', 'straight')),
                _quickBtn('完整序列', _testFullSequence),
                _quickBtn('镜像切换', _ctrl.toggleMirror),
                _quickBtn('停止', _ctrl.stop),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickBtn(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildSequenceList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.grey[300],
          child: Row(
            children: [
              const Text('当前序列', style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton.icon(
                onPressed: _sequence.isNotEmpty ? () => setState(_sequence.clear) : null,
                icon: const Icon(Icons.clear_all),
                label: const Text('清空'),
              ),
              TextButton.icon(
                onPressed: _sequence.isNotEmpty ? _copySequenceCode : null,
                icon: const Icon(Icons.copy),
                label: const Text('复制代码'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _sequence.isEmpty
              ? const Center(child: Text('点击"加入序列"添加指令'))
              : ReorderableListView.builder(
                  itemCount: _sequence.length,
                  onReorder: (oldIdx, newIdx) {
                    setState(() {
                      if (newIdx > oldIdx) newIdx--;
                      final item = _sequence.removeAt(oldIdx);
                      _sequence.insert(newIdx, item);
                    });
                  },
                  itemBuilder: (context, index) {
                    final cmd = _sequence[index];
                    return ListTile(
                      key: ValueKey(index),
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text('M1: ${cmd.dir1.displayName} ${cmd.time1} | M2: ${cmd.dir2.displayName} ${cmd.time2}'),
                      subtitle: cmd.delayAfter != null ? Text('延迟: ${cmd.delayAfter}ms') : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => setState(() => _sequence.removeAt(index)),
                      ),
                      onTap: () => _editCommand(index),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _sendCommand() async {
    final cmd = MotorCmd(
      dir1: _dir1, time1: _time1,
      dir2: _dir2, time2: _time2,
      delayAfter: _delayAfter,
    );
    await _ctrl.sendRaw(cmd);
    _showMsg('已发送: $cmd');
  }

  void _addToSequence() {
    setState(() {
      _sequence.add(MotorCmd(
        dir1: _dir1, time1: _time1,
        dir2: _dir2, time2: _time2,
        delayAfter: _delayAfter,
      ));
    });
  }

  void _sendSequence() async {
    for (final cmd in _sequence) {
      await _ctrl.sendRaw(cmd);
      await Future.delayed(Duration(
        milliseconds: (cmd.time1 + cmd.time2) * 10 + (cmd.delayAfter ?? 100),
      ));
    }
    _showMsg('序列发送完成');
  }

  void _editCommand(int index) {
    final cmd = _sequence[index];
    setState(() {
      _dir1 = cmd.dir1;
      _time1 = cmd.time1;
      _dir2 = cmd.dir2;
      _time2 = cmd.time2;
      _delayAfter = cmd.delayAfter;
      _sequence.removeAt(index);
    });
  }

  void _copySequenceCode() {
    final code = _sequence.map((c) => '      ${c.toCodeString()},').join('\n');
    Clipboard.setData(ClipboardData(text: code));
    _showMsg('代码已复制');
  }

  Future<void> _testTransform(String from, String to) async {
    final ok = await _ctrl.transform(from, to);
    if (!ok) _showMsg('变换失败');
  }

  Future<void> _testFullSequence() async {
    await _ctrl.runGameSequence();
  }

  void _showTransformList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        expand: false,
        builder: (context, scrollCtrl) => TransformListView(
          onSelect: (t) {
            Navigator.pop(context);
            _loadTransform(t);
          },
        ),
      ),
    );
  }

  void _loadTransform(Transform t) {
    setState(() {
      _selectedTransform = t;
      _sequence.clear();
      _sequence.addAll(t.cmds);
    });
    _showMsg('已加载: ${t.displayName}');
  }

  void _showGeneratedCode() {
    if (_sequence.isEmpty) {
      _showMsg('序列为空');
      return;
    }
    
    final code = '''Transform(
  from: Shapes.${_ctrl.currentShape ?? 'straight'},
  to: Shapes.目标形状,
  cmds: [
${_sequence.map((c) => '    ${c.toCodeString()},').join('\n')}
  ],
  note: '备注',
),''';  

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('生成的代码'),
        content: SingleChildScrollView(
          child: SelectableText(code),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              Navigator.pop(context);
              _showMsg('已复制');
            },
            child: const Text('复制'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }
}

/// 变换列表视图
class TransformListView extends StatelessWidget {
  final Function(Transform) onSelect;
  
  const TransformListView({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final transforms = ShapeTransforms.all;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text('选择变换', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: transforms.length,
            itemBuilder: (context, index) {
              final t = transforms[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: t.isMirrorTransform ? Colors.blue : Colors.green,
                  child: Text('${t.cmds.length}'),
                ),
                title: Text(t.displayName),
                subtitle: Text(t.note ?? '无备注'),
                trailing: Text('${t.estimatedDuration}ms'),
                onTap: () => onSelect(t),
              );
            },
          ),
        ),
      ],
    );
  }
}
