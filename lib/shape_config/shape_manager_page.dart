import 'package:code/shape_config/motor_cmd.dart';
import 'package:code/shape_config/shape_ctrl.dart';
import 'package:code/shape_config/shape_transforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 形状管理页面 - 查看和编辑所有变换
class ShapeManagerPage extends StatefulWidget {
  const ShapeManagerPage({super.key});

  @override
  State<ShapeManagerPage> createState() => _ShapeManagerPageState();
}

class _ShapeManagerPageState extends State<ShapeManagerPage> {
  String? _filterShape;
  String? _filterTag;

  @override
  Widget build(BuildContext context) {
    var transforms = ShapeTransforms.all;
    
    if (_filterShape != null) {
      transforms = transforms.where((t) => 
        t.from == _filterShape || t.to == _filterShape
      ).toList();
    }
    if (_filterTag != null) {
      transforms = transforms.where((t) => t.tag == _filterTag).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('形状变换管理'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (v) => setState(() => _filterTag = v == 'all' ? null : v),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('全部')),
              const PopupMenuItem(value: 'mirror', child: Text('镜像变换')),
              const PopupMenuItem(value: 'game', child: Text('游戏流程')),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'check', child: Text('检查完整性')),
              const PopupMenuItem(value: 'export', child: Text('导出配置')),
              const PopupMenuItem(value: 'stats', child: Text('统计信息')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 形状筛选
          _buildShapeFilter(),
          
          // 统计
          _buildStats(),
          
          // 列表
          Expanded(
            child: ListView.builder(
              itemCount: transforms.length,
              itemBuilder: (context, index) => _buildTransformCard(transforms[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShapeFilter() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(
              label: const Text('全部'),
              selected: _filterShape == null,
              onSelected: (_) => setState(() => _filterShape = null),
            ),
            ...Shapes.all.expand((shape) => [
              const SizedBox(width: 8),
              FilterChip(
                label: Text(Shapes.getName(shape)),
                selected: _filterShape == shape,
                onSelected: (_) => setState(() => _filterShape = shape),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    final total = ShapeTransforms.all.length;
    final mirrorCount = ShapeTransforms.getAllMirrorTransforms().length;
    final crossCount = ShapeTransforms.getAllCrossTransforms().length;
    final missing = ShapeTransforms.getMissingTransforms();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('总变换', total.toString()),
          _statItem('镜像', mirrorCount.toString()),
          _statItem('跨形状', crossCount.toString()),
          _statItem('缺失', missing.length.toString(), 
            color: missing.isEmpty ? Colors.green : Colors.red),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(value, style: TextStyle(
          fontSize: 24, 
          fontWeight: FontWeight.bold,
          color: color,
        )),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildTransformCard(Transform t) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: t.isMirrorTransform ? Colors.blue : Colors.green,
          child: Text('${t.cmds.length}'),
        ),
        title: Text(t.displayName),
        subtitle: Row(
          children: [
            Chip(
              label: Text(t.tag ?? '无标签', style: const TextStyle(fontSize: 10)),
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 8),
            Text('${t.estimatedDuration}ms'),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (t.note != null) ...[
                  Text('备注: ${t.note}'),
                  const SizedBox(height: 8),
                ],
                const Text('指令列表:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...t.cmds.asMap().entries.map((e) => 
                  ListTile(
                    dense: true,
                    leading: Text('${e.key + 1}'),
                    title: Text('M1: ${e.value.dir1.displayName} ${e.value.time1} | '
                               'M2: ${e.value.dir2.displayName} ${e.value.time2}'),
                    subtitle: e.value.delayAfter != null 
                        ? Text('延迟: ${e.value.delayAfter}ms')
                        : null,
                  )
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _testTransform(t),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('测试'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _copyCode(t),
                      icon: const Icon(Icons.copy),
                      label: const Text('复制代码'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'check':
        _checkCompleteness();
        break;
      case 'export':
        _exportConfig();
        break;
      case 'stats':
        _showStats();
        break;
    }
  }

  void _checkCompleteness() {
    final missing = ShapeTransforms.getMissingTransforms();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('完整性检查 (${missing.isEmpty ? '通过' : '缺失${missing.length}项'})'),
        content: SizedBox(
          width: double.maxFinite,
          child: missing.isEmpty
              ? const Text('✓ 所有变换已配置')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: missing.length,
                  itemBuilder: (context, index) => 
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.warning, color: Colors.orange),
                      title: Text(missing[index]),
                    ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _exportConfig() {
    final code = ShapeTransforms.generateConfigCode();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('完整配置代码'),
        content: SingleChildScrollView(
          child: SelectableText(code),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已复制')),
              );
            },
            child: const Text('复制全部'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showStats() {
    final stats = <String, dynamic>{
      '总变换数': ShapeTransforms.all.length,
      '镜像变换': ShapeTransforms.getAllMirrorTransforms().length,
      '跨形状变换': ShapeTransforms.getAllCrossTransforms().length,
      '平均指令数': ShapeTransforms.all.isEmpty ? 0 
          : ShapeTransforms.all.map((t) => t.cmds.length).reduce((a, b) => a + b) / ShapeTransforms.all.length,
      '缺失配置': ShapeTransforms.getMissingTransforms().length,
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('统计信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: stats.entries.map((e) => 
            ListTile(
              title: Text(e.key),
              trailing: Text(e.value.toString()),
            )
          ).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Future<void> _testTransform(Transform t) async {
    final ctrl = ShapeCtrl();
    await ctrl.transform(t.from, t.to);
  }

  void _copyCode(Transform t) {
    Clipboard.setData(ClipboardData(text: t.toCodeString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('代码已复制')),
    );
  }
}
