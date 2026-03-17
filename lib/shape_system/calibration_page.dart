import 'package:code/shape_system/motor_commands.dart';
import 'package:code/shape_system/shape_transformation.dart';
import 'package:code/shape_system/shape_types.dart';
import 'package:flutter/material.dart';

/// 调试页面 - 用于调试形状变换参数
class ShapeCalibrationPage extends StatefulWidget {
  const ShapeCalibrationPage({super.key});

  @override
  State<ShapeCalibrationPage> createState() => _ShapeCalibrationPageState();
}

class _ShapeCalibrationPageState extends State<ShapeCalibrationPage> {
  final repository = ShapeTransformationRepository();
  
  // 当前选择的形状
  BaseShape? _fromShape;
  bool _fromMirrored = false;
  BaseShape? _toShape;
  bool _toMirrored = false;
  
  // 指令列表
  final List<DualMotorCommand> _commands = [];
  
  // 当前编辑的指令索引
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    repository.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('形状变换调试'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTransformation,
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _testTransformation,
          ),
        ],
      ),
      body: Column(
        children: [
          // 形状选择区
          _buildShapeSelector(),
          
          const Divider(),
          
          // 指令列表
          Expanded(
            child: _buildCommandList(),
          ),
          
          // 添加指令按钮
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildShapeSelector() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 起始形状
          Row(
            children: [
              const Text('从: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: DropdownButton<BaseShape>(
                  value: _fromShape,
                  hint: const Text('选择形状'),
                  isExpanded: true,
                  items: BaseShape.values.map((shape) {
                    return DropdownMenuItem(
                      value: shape,
                      child: Text(shape.displayName),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _fromShape = v),
                ),
              ),
              Checkbox(
                value: _fromMirrored,
                onChanged: (v) => setState(() => _fromMirrored = v ?? false),
              ),
              const Text('镜像'),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // 目标形状
          Row(
            children: [
              const Text('到: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: DropdownButton<BaseShape>(
                  value: _toShape,
                  hint: const Text('选择形状'),
                  isExpanded: true,
                  items: BaseShape.values.map((shape) {
                    return DropdownMenuItem(
                      value: shape,
                      child: Text(shape.displayName),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _toShape = v),
                ),
              ),
              Checkbox(
                value: _toMirrored,
                onChanged: (v) => setState(() => _toMirrored = v ?? false),
              ),
              const Text('镜像'),
            ],
          ),
          
          // 加载已有参数
          if (_fromShape != null && _toShape != null)
            TextButton(
              onPressed: _loadExisting,
              child: const Text('加载已保存的参数'),
            ),
        ],
      ),
    );
  }

  Widget _buildCommandList() {
    if (_commands.isEmpty) {
      return const Center(
        child: Text('点击底部按钮添加电机指令'),
      );
    }

    return ListView.builder(
      itemCount: _commands.length,
      itemBuilder: (context, index) {
        final cmd = _commands[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            title: Text('指令 ${index + 1}'),
            subtitle: Text(
              'M1: ${_directionName(cmd.motor1.direction)} ${cmd.motor1.duration} | '
              'M2: ${_directionName(cmd.motor2.direction)} ${cmd.motor2.duration}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editCommand(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteCommand(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _addCommand,
              icon: const Icon(Icons.add),
              label: const Text('添加指令'),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: _commands.isNotEmpty ? _sendAllCommands : null,
            icon: const Icon(Icons.send),
            label: const Text('发送全部'),
          ),
        ],
      ),
    );
  }

  String _directionName(MotorDirection d) {
    switch (d) {
      case MotorDirection.stop:
        return '停';
      case MotorDirection.forward:
        return '正';
      case MotorDirection.reversal:
        return '反';
    }
  }

  void _addCommand() {
    setState(() {
      _commands.add(const DualMotorCommand(
        motor1: MotorCommand(direction: MotorDirection.stop, duration: 0),
        motor2: MotorCommand(direction: MotorDirection.stop, duration: 0),
      ));
    });
    _editCommand(_commands.length - 1);
  }

  void _editCommand(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CommandEditor(
        command: _commands[index],
        onSave: (newCmd) {
          setState(() {
            _commands[index] = newCmd;
          });
          Navigator.pop(context);
        },
        onTest: (cmd) => _testSingleCommand(cmd),
      ),
    );
  }

  void _deleteCommand(int index) {
    setState(() {
      _commands.removeAt(index);
    });
  }

  Future<void> _loadExisting() async {
    if (_fromShape == null || _toShape == null) return;
    
    final from = ShapeId(shape: _fromShape!, orientation: _fromMirrored ? ShapeOrientation.mirrored : ShapeOrientation.normal);
    final to = ShapeId(shape: _toShape!, orientation: _toMirrored ? ShapeOrientation.mirrored : ShapeOrientation.normal);
    
    final existing = repository.getTransformation(from, to);
    if (existing != null) {
      setState(() {
        _commands.clear();
        _commands.addAll(existing.sequence.commands);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已加载保存的参数')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有找到已保存的参数')),
      );
    }
  }

  Future<void> _saveTransformation() async {
    if (_fromShape == null || _toShape == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择起始和目标形状')),
      );
      return;
    }

    if (_commands.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少添加一条指令')),
      );
      return;
    }

    final from = ShapeId(shape: _fromShape!, orientation: _fromMirrored ? ShapeOrientation.mirrored : ShapeOrientation.normal);
    final to = ShapeId(shape: _toShape!, orientation: _toMirrored ? ShapeOrientation.mirrored : ShapeOrientation.normal);

    final transformation = ShapeTransformation(
      from: from,
      to: to,
      sequence: TransformationSequence(
        name: '${from.key}_to_${to.key}',
        commands: List.from(_commands),
        description: '调试保存',
      ),
      lastModified: DateTime.now(),
    );

    await repository.saveTransformation(transformation);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存成功')),
    );
  }

  Future<void> _testTransformation() async {
    if (_commands.isEmpty) return;
    
    // 这里需要接入你的ShapeController
    // await shapeController.sendRawCommands(_commands);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('发送测试指令...')),
    );
  }

  Future<void> _testSingleCommand(DualMotorCommand cmd) async {
    // 这里需要接入你的ShapeController
    // await shapeController.sendRawCommand(cmd);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('测试指令: M1=${cmd.motor1.direction.name}, M2=${cmd.motor2.direction.name}')),
    );
  }

  Future<void> _sendAllCommands() async {
    for (final cmd in _commands) {
      await _testSingleCommand(cmd);
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}

/// 指令编辑器
class CommandEditor extends StatefulWidget {
  final DualMotorCommand command;
  final Function(DualMotorCommand) onSave;
  final Function(DualMotorCommand) onTest;

  const CommandEditor({
    super.key,
    required this.command,
    required this.onSave,
    required this.onTest,
  });

  @override
  State<CommandEditor> createState() => _CommandEditorState();
}

class _CommandEditorState extends State<CommandEditor> {
  late MotorDirection _motor1Dir;
  late int _motor1Duration;
  late MotorDirection _motor2Dir;
  late int _motor2Duration;

  @override
  void initState() {
    super.initState();
    _motor1Dir = widget.command.motor1.direction;
    _motor1Duration = widget.command.motor1.duration;
    _motor2Dir = widget.command.motor2.direction;
    _motor2Duration = widget.command.motor2.duration;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('编辑电机指令', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          // 电机1
          _buildMotorControl('电机1', _motor1Dir, _motor1Duration, (dir, dur) {
            setState(() {
              _motor1Dir = dir;
              _motor1Duration = dur;
            });
          }),
          
          const Divider(),
          
          // 电机2
          _buildMotorControl('电机2', _motor2Dir, _motor2Duration, (dir, dur) {
            setState(() {
              _motor2Dir = dir;
              _motor2Duration = dur;
            });
          }),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave(DualMotorCommand(
                      motor1: MotorCommand(direction: _motor1Dir, duration: _motor1Duration),
                      motor2: MotorCommand(direction: _motor2Dir, duration: _motor2Duration),
                    ));
                  },
                  child: const Text('保存'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  widget.onTest(DualMotorCommand(
                    motor1: MotorCommand(direction: _motor1Dir, duration: _motor1Duration),
                    motor2: MotorCommand(direction: _motor2Dir, duration: _motor2Duration),
                  ));
                },
                child: const Text('测试'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMotorControl(
    String label,
    MotorDirection direction,
    int duration,
    Function(MotorDirection, int) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: SegmentedButton<MotorDirection>(
                segments: const [
                  ButtonSegment(value: MotorDirection.stop, label: Text('停')),
                  ButtonSegment(value: MotorDirection.forward, label: Text('正')),
                  ButtonSegment(value: MotorDirection.reversal, label: Text('反')),
                ],
                selected: {direction},
                onSelectionChanged: (set) {
                  if (set.isNotEmpty) onChanged(set.first, duration);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('时长: '),
            Expanded(
              child: Slider(
                value: duration.toDouble(),
                min: 0,
                max: 255,
                divisions: 255,
                label: duration.toString(),
                onChanged: (v) => onChanged(direction, v.toInt()),
              ),
            ),
            SizedBox(
              width: 50,
              child: Text('$duration', textAlign: TextAlign.center),
            ),
          ],
        ),
      ],
    );
  }
}
