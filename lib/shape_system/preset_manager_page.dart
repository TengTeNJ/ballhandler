import 'dart:convert';
import 'package:code/shape_system/motor_commands.dart';
import 'package:code/shape_system/shape_transformation.dart';
import 'package:code/shape_system/shape_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 预设管理页面 - 管理所有形状变换预设
class ShapePresetManagerPage extends StatefulWidget {
  const ShapePresetManagerPage({super.key});

  @override
  State<ShapePresetManagerPage> createState() => _ShapePresetManagerPageState();
}

class _ShapePresetManagerPageState extends State<ShapePresetManagerPage> {
  final repository = ShapeTransformationRepository();
  Map<String, ShapeTransformation> _transformations = {};
  BaseShape? _filterShape;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await repository.initialize();
    setState(() {
      _transformations = Map.from(repository.transformations);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filterShape != null
        ? _transformations.values.where((t) => 
            t.from.shape == _filterShape || t.to.shape == _filterShape
          ).toList()
        : _transformations.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('变换预设管理'),
        actions: [
          // 筛选
          PopupMenuButton<BaseShape?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (shape) => setState(() => _filterShape = shape),
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('全部')),
              ...BaseShape.values.map((s) => 
                PopupMenuItem(value: s, child: Text(s.displayName))
              ),
            ],
          ),
          // 更多操作
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'export', child: Text('导出全部')),
              const PopupMenuItem(value: 'import', child: Text('导入')),
              const PopupMenuItem(value: 'clear', child: Text('清空全部')),
              const PopupMenuItem(value: 'generate', child: Text('生成默认结构')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 统计信息
          _buildStats(),
          
          // 预设列表
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text('暂无预设'))
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final transform = filteredList[index];
                      return _buildPresetCard(transform);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/shape_calibration'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStats() {
    final total = _transformations.length;
    final completePairs = _countCompletePairs();
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('总预设数', total.toString()),
          _statItem('完整形状对', '$completePairs/${BaseShape.values.length}'),
          _statItem('缺失', '${BaseShape.values.length - completePairs}'),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildPresetCard(ShapeTransformation transform) {
    final isComplete = transform.sequence.commands.isNotEmpty;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isComplete ? Colors.green : Colors.orange,
          child: Icon(isComplete ? Icons.check : Icons.edit, color: Colors.white),
        ),
        title: Text(transform.displayName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('指令数: ${transform.sequence.commands.length}'),
            if (transform.lastModified != null)
              Text('修改: ${_formatDate(transform.lastModified!)}', 
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () => _testTransformation(transform),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteTransformation(transform),
            ),
          ],
        ),
        onTap: () => _editTransformation(transform),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  int _countCompletePairs() {
    final Set<String> completeShapes = {};
    for (final t in _transformations.values) {
      if (t.sequence.commands.isNotEmpty) {
        completeShapes.add(t.from.shape.key);
        completeShapes.add(t.to.shape.key);
      }
    }
    return completeShapes.length;
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'export':
        _exportAll();
        break;
      case 'import':
        _importData();
        break;
      case 'clear':
        _clearAll();
        break;
      case 'generate':
        _generateDefaultStructure();
        break;
    }
  }

  Future<void> _exportAll() async {
    final data = repository.exportAll();
    final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
    
    await Clipboard.setData(ClipboardData(text: jsonStr));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已复制到剪贴板')),
    );
  }

  Future<void> _importData() async {
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboard?.text == null) return;

    try {
      final data = jsonDecode(clipboard!.text!);
      await repository.importAll(data);
      await _loadData();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('导入成功')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导入失败: $e')),
      );
    }
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清空'),
        content: const Text('这将删除所有保存的变换参数，不可恢复！'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('清空')),
        ],
      ),
    );

    if (confirm == true) {
      await repository.clearAll();
      await _loadData();
    }
  }

  /// 生成默认的变换结构（空模板）
  Future<void> _generateDefaultStructure() async {
    final List<ShapeTransformation> defaults = [];
    
    // 为每种形状生成：正常->镜像，镜像->正常
    for (final shape in BaseShape.values) {
      final normal = ShapeId(shape: shape, orientation: ShapeOrientation.normal);
      final mirrored = ShapeId(shape: shape, orientation: ShapeOrientation.mirrored);
      
      // 正常 -> 镜像
      defaults.add(ShapeTransformation(
        from: normal,
        to: mirrored,
        sequence: TransformationSequence(
          name: '${shape.key}_to_mirror',
          commands: [],
          description: '待调试',
        ),
      ));
      
      // 镜像 -> 正常
      defaults.add(ShapeTransformation(
        from: mirrored,
        to: normal,
        sequence: TransformationSequence(
          name: '${shape.key}_mirror_to_normal',
          commands: [],
          description: '待调试',
        ),
      ));
    }

    // 生成形状间的变换（用于游戏流程）
    for (int i = 0; i < BaseShape.values.length - 1; i++) {
      final current = BaseShape.values[i];
      final next = BaseShape.values[i + 1];
      
      final currentMirrored = ShapeId(shape: current, orientation: ShapeOrientation.mirrored);
      final nextNormal = ShapeId(shape: next, orientation: ShapeOrientation.normal);
      
      defaults.add(ShapeTransformation(
        from: currentMirrored,
        to: nextNormal,
        sequence: TransformationSequence(
          name: '${current.key}_mirror_to_${next.key}',
          commands: [],
          description: '游戏流程变换，待调试',
        ),
      ));
    }

    // 保存所有默认结构
    for (final t in defaults) {
      if (repository.getTransformation(t.from, t.to) == null) {
        await repository.saveTransformation(t);
      }
    }

    await _loadData();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已生成 ${defaults.length} 个默认结构')),
    );
  }

  Future<void> _testTransformation(ShapeTransformation transform) async {
    // 接入你的测试逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('测试: ${transform.displayName}')),
    );
  }

  Future<void> _deleteTransformation(ShapeTransformation transform) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('删除 ${transform.displayName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('删除')),
        ],
      ),
    );

    if (confirm == true) {
      await repository.deleteTransformation(transform.id);
      await _loadData();
    }
  }

  void _editTransformation(ShapeTransformation transform) {
    // 导航到调试页面并加载该变换
    Navigator.pushNamed(
      context, 
      '/shape_calibration',
      arguments: transform,
    );
  }
}

/// 快速调试面板 - 可以在游戏页面悬浮显示
class QuickCalibrationPanel extends StatelessWidget {
  final VoidCallback? onOpenFullCalibration;
  
  const QuickCalibrationPanel({super.key, this.onOpenFullCalibration});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('快速调试', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _quickTest(context, 'reset'),
                  child: const Text('复位'),
                ),
                ElevatedButton(
                  onPressed: () => _quickTest(context, 'straight'),
                  child: const Text('直线'),
                ),
                ElevatedButton(
                  onPressed: onOpenFullCalibration,
                  child: const Text('完整调试'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _quickTest(BuildContext context, String action) {
    // 快速测试逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('快速测试: $action')),
    );
  }
}
