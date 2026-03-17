import 'dart:convert';
import 'package:code/shape_system/motor_commands.dart';
import 'package:code/shape_system/shape_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 变换路径类型
enum TransformPath {
  toMirror,    // 形状A -> 形状A镜像
  toNormal,    // 形状A镜像 -> 形状A
  toNextShape, // 形状A -> 形状B（游戏流程中的下一个形状）
}

extension TransformPathExtension on TransformPath {
  String get displayName {
    switch (this) {
      case TransformPath.toMirror:
        return '→ 镜像';
      case TransformPath.toNormal:
        return '→ 正常';
      case TransformPath.toNextShape:
        return '→ 下一形状';
    }
  }

  String get key {
    switch (this) {
      case TransformPath.toMirror:
        return 'to_mirror';
      case TransformPath.toNormal:
        return 'to_normal';
      case TransformPath.toNextShape:
        return 'to_next';
    }
  }
}

/// 变换定义（从一个形状到另一个形状的变换参数）
class ShapeTransformation {
  final ShapeId from;
  final ShapeId to;
  final TransformationSequence sequence;
  final DateTime? lastModified;
  final String? notes; // 调试笔记

  const ShapeTransformation({
    required this.from,
    required this.to,
    required this.sequence,
    this.lastModified,
    this.notes,
  });

  /// 变换路径类型
  TransformPath get pathType {
    if (from.shape == to.shape) {
      return from.isMirrored ? TransformPath.toNormal : TransformPath.toMirror;
    }
    return TransformPath.toNextShape;
  }

  /// 唯一标识
  String get id => '${from.key}_to_${to.key}';

  /// 显示名称
  String get displayName => '${from.displayName} ${pathType.displayName} ${to.displayName}';

  ShapeTransformation copyWith({
    ShapeId? from,
    ShapeId? to,
    TransformationSequence? sequence,
    DateTime? lastModified,
    String? notes,
  }) {
    return ShapeTransformation(
      from: from ?? this.from,
      to: to ?? this.to,
      sequence: sequence ?? this.sequence,
      lastModified: lastModified ?? this.lastModified,
      notes: notes ?? this.notes,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'from': {'shape': from.shape.key, 'mirrored': from.isMirrored},
      'to': {'shape': to.shape.key, 'mirrored': to.isMirrored},
      'sequence': {
        'name': sequence.name,
        'description': sequence.description,
        'commands': sequence.commands.map((cmd) => {
          'motor1': {'direction': cmd.motor1.direction.index, 'duration': cmd.motor1.duration},
          'motor2': {'direction': cmd.motor2.direction.index, 'duration': cmd.motor2.duration},
        }).toList(),
      },
      'lastModified': lastModified?.toIso8601String(),
      'notes': notes,
    };
  }

  /// 从JSON解析
  factory ShapeTransformation.fromJson(Map<String, dynamic> json) {
    final fromShape = BaseShapeExtension.fromKey(json['from']['shape'])!;
    final toShape = BaseShapeExtension.fromKey(json['to']['shape'])!;
    
    return ShapeTransformation(
      from: ShapeId(
        shape: fromShape,
        orientation: json['from']['mirrored'] ? ShapeOrientation.mirrored : ShapeOrientation.normal,
      ),
      to: ShapeId(
        shape: toShape,
        orientation: json['to']['mirrored'] ? ShapeOrientation.mirrored : ShapeOrientation.normal,
      ),
      sequence: TransformationSequence(
        name: json['sequence']['name'],
        description: json['sequence']['description'],
        commands: (json['sequence']['commands'] as List).map((cmd) => DualMotorCommand(
          motor1: MotorCommand(
            direction: MotorDirection.values[cmd['motor1']['direction']],
            duration: cmd['motor1']['duration'],
          ),
          motor2: MotorCommand(
            direction: MotorDirection.values[cmd['motor2']['direction']],
            duration: cmd['motor2']['duration'],
          ),
        )).toList(),
      ),
      lastModified: json['lastModified'] != null 
          ? DateTime.parse(json['lastModified']) 
          : null,
      notes: json['notes'],
    );
  }
}

/// 形状变换仓库 - 管理所有变换参数
class ShapeTransformationRepository {
  static final ShapeTransformationRepository _instance = ShapeTransformationRepository._internal();
  factory ShapeTransformationRepository() => _instance;
  ShapeTransformationRepository._internal();

  final Map<String, ShapeTransformation> _transformations = {};
  bool _initialized = false;

  /// 获取所有变换
  Map<String, ShapeTransformation> get transformations => Map.unmodifiable(_transformations);

  /// 初始化 - 从本地存储加载
  Future<void> initialize() async {
    if (_initialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('shape_transform_'));
    
    for (final key in keys) {
      final jsonStr = prefs.getString(key);
      if (jsonStr != null) {
        try {
          final json = jsonDecode(jsonStr);
          final transform = ShapeTransformation.fromJson(json);
          _transformations[transform.id] = transform;
        } catch (e) {
          print('加载变换参数失败: $key, error: $e');
        }
      }
    }
    
    _initialized = true;
  }

  /// 获取变换
  ShapeTransformation? getTransformation(ShapeId from, ShapeId to) {
    final id = '${from.key}_to_${to.key}';
    return _transformations[id];
  }

  /// 保存变换
  Future<void> saveTransformation(ShapeTransformation transformation) async {
    _transformations[transformation.id] = transformation;
    
    final prefs = await SharedPreferences.getInstance();
    final key = 'shape_transform_${transformation.id}';
    await prefs.setString(key, jsonEncode(transformation.toJson()));
  }

  /// 删除变换
  Future<void> deleteTransformation(String id) async {
    _transformations.remove(id);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('shape_transform_$id');
  }

  /// 获取形状的所有相关变换
  List<ShapeTransformation> getTransformationsForShape(BaseShape shape) {
    return _transformations.values.where((t) => 
      t.from.shape == shape || t.to.shape == shape
    ).toList();
  }

  /// 获取变换路径（用于游戏流程）
  /// 例如: [ShapeA, ShapeA镜像, ShapeB, ShapeB镜像, ...]
  List<ShapeTransformation> getGameSequence(List<BaseShape> shapes) {
    final List<ShapeTransformation> sequence = [];
    
    for (int i = 0; i < shapes.length; i++) {
      final currentShape = shapes[i];
      final normal = ShapeId(shape: currentShape, orientation: ShapeOrientation.normal);
      final mirrored = ShapeId(shape: currentShape, orientation: ShapeOrientation.mirrored);
      
      // 正常 -> 镜像
      final toMirror = getTransformation(normal, mirrored);
      if (toMirror != null) sequence.add(toMirror);
      
      // 镜像 -> 正常（如果只有一个形状，需要回到正常）
      if (i == shapes.length - 1) {
        final toNormal = getTransformation(mirrored, normal);
        if (toNormal != null) sequence.add(toNormal);
      } else {
        // 镜像 -> 下一个形状的正常状态
        final nextShape = shapes[i + 1];
        final nextNormal = ShapeId(shape: nextShape, orientation: ShapeOrientation.normal);
        final toNext = getTransformation(mirrored, nextNormal);
        if (toNext != null) sequence.add(toNext);
      }
    }
    
    return sequence;
  }

  /// 导出所有参数（用于备份或分享）
  Map<String, dynamic> exportAll() {
    return {
      'version': 1,
      'exportTime': DateTime.now().toIso8601String(),
      'transformations': _transformations.map((k, v) => MapEntry(k, v.toJson())),
    };
  }

  /// 导入参数
  Future<void> importAll(Map<String, dynamic> data) async {
    final transforms = data['transformations'] as Map<String, dynamic>?;
    if (transforms == null) return;
    
    for (final entry in transforms.entries) {
      try {
        final transform = ShapeTransformation.fromJson(entry.value);
        await saveTransformation(transform);
      } catch (e) {
        print('导入变换失败: ${entry.key}, error: $e');
      }
    }
  }

  /// 清空所有
  Future<void> clearAll() async {
    _transformations.clear();
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('shape_transform_'));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
