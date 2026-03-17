import 'motor_cmd.dart';

/// 8种基础形状
class Shapes {
  static const String straight = 'straight';      // 直线
  static const String shape2 = 'shape2';          // 2字形
  static const String lShape = 'l_shape';         // L形
  static const String omega = 'omega';            // Ω形
  static const String pentagon = 'pentagon';      // 五边形
  static const String smile = 'smile';            // 微笑形
  static const String zigzag = 'zigzag';          // Z字形
  static const String cat = 'cat';                // 猫形

  static const List<String> all = [
    straight, shape2, lShape, omega, 
    pentagon, smile, zigzag, cat
  ];

  static const Map<String, String> names = {
    straight: '直线',
    shape2: '2字形',
    lShape: 'L形',
    omega: 'Ω形',
    pentagon: '五边形',
    smile: '微笑形',
    zigzag: 'Z字形',
    cat: '猫形',
  };

  static String getName(String shape) {
    if (isMirror(shape)) {
      final base = baseOf(shape);
      return '${names[base] ?? shape}(镜像)';
    }
    return names[shape] ?? shape;
  }

  static String mirrorOf(String shape) => '${shape}_mirror';
  static bool isMirror(String shape) => shape.endsWith('_mirror');
  static String baseOf(String shape) => shape.replaceAll('_mirror', '');
  
  /// 获取形状的镜像版本（如果是镜像则返回原形状）
  static String toggleMirror(String shape) {
    if (isMirror(shape)) return baseOf(shape);
    return mirrorOf(shape);
  }
}

/// 变换定义（从A到B的指令序列）
class Transform {
  final String from;    // 如 "straight"
  final String to;      // 如 "straight_mirror"
  final List<MotorCmd> cmds;
  final String? note;   // 备注
  final String? tag;    // 标签，用于分组

  const Transform({
    required this.from,
    required this.to,
    required this.cmds,
    this.note,
    this.tag,
  });

  String get id => '${from}_to_$to';
  String get fromName => Shapes.getName(from);
  String get toName => Shapes.getName(to);
  String get displayName => '$fromName → $toName';

  /// 是否是镜像变换（同形状的正常↔镜像）
  bool get isMirrorTransform => Shapes.baseOf(from) == Shapes.baseOf(to);
  
  /// 是否是跨形状变换
  bool get isCrossTransform => Shapes.baseOf(from) != Shapes.baseOf(to);

  List<List<int>> toBleDataList() => cmds.map((c) => c.toBleData()).toList();

  /// 总执行时长估算（ms）
  int get estimatedDuration {
    int total = 0;
    for (final cmd in cmds) {
      // 假设每个时间单位是10ms
      total += (cmd.time1 + cmd.time2) * 10;
      if (cmd.delayAfter != null) total += cmd.delayAfter!;
    }
    return total;
  }

  Transform copyWith({
    String? from,
    String? to,
    List<MotorCmd>? cmds,
    String? note,
    String? tag,
  }) {
    return Transform(
      from: from ?? this.from,
      to: to ?? this.to,
      cmds: cmds ?? this.cmds,
      note: note ?? this.note,
      tag: tag ?? this.tag,
    );
  }

  @override
  String toString() => 'Transform($id, ${cmds.length}条指令)';

  /// 生成配置代码
  String toCodeString() {
    final buffer = StringBuffer();
    buffer.writeln('  // ${note ?? displayName}');
    buffer.writeln('  Transform(');
    buffer.writeln('    from: Shapes.$from,');
    buffer.writeln('    to: Shapes.${Shapes.isMirror(to) ? 'mirrorOf(Shapes.${Shapes.baseOf(to)})' : to},');
    buffer.writeln('    cmds: [');
    for (final cmd in cmds) {
      buffer.writeln('      ${cmd.toCodeString()},');
    }
    buffer.writeln('    ],');
    if (note != null) {
      buffer.writeln('    note: \'$note\',');
    }
    buffer.write('  ),');
    return buffer.toString();
  }
}

/// ============================================
/// 形状变换配置库
/// ============================================
class ShapeTransforms {
  ShapeTransforms._();

  /// 所有变换定义
  static const List<Transform> all = [
    // ========== 直线形状 ==========
    Transform(
      from: Shapes.straight,
      to: Shapes.mirrorOf(Shapes.straight),
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 100, dir2: MotorDir.reversal, time2: 100),
      ],
      note: '直线 → 镜像',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.straight),
      to: Shapes.straight,
      cmds: [
        MotorCmd(dir1: MotorDir.reversal, time1: 100, dir2: MotorDir.forward, time2: 100),
      ],
      note: '直线镜像 → 原状',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.straight),
      to: Shapes.shape2,
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 80, dir2: MotorDir.forward, time2: 120),
      ],
      note: '直线镜像 → 2字形',
      tag: 'game',
    ),

    // ========== 2字形 ==========
    Transform(
      from: Shapes.shape2,
      to: Shapes.mirrorOf(Shapes.shape2),
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 100, dir2: MotorDir.reversal, time2: 100),
      ],
      note: '2字形 → 镜像',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.shape2),
      to: Shapes.shape2,
      cmds: [
        MotorCmd(dir1: MotorDir.reversal, time1: 100, dir2: MotorDir.forward, time2: 100),
      ],
      note: '2字形镜像 → 原状',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.shape2),
      to: Shapes.lShape,
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 90, dir2: MotorDir.reversal, time2: 60),
      ],
      note: '2字形镜像 → L形',
      tag: 'game',
    ),

    // ========== L形 ==========
    Transform(
      from: Shapes.lShape,
      to: Shapes.mirrorOf(Shapes.lShape),
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 100, dir2: MotorDir.reversal, time2: 100),
      ],
      note: 'L形 → 镜像',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.lShape),
      to: Shapes.lShape,
      cmds: [
        MotorCmd(dir1: MotorDir.reversal, time1: 100, dir2: MotorDir.forward, time2: 100),
      ],
      note: 'L形镜像 → 原状',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.lShape),
      to: Shapes.omega,
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 110, dir2: MotorDir.forward, time2: 70),
      ],
      note: 'L形镜像 → Ω形',
      tag: 'game',
    ),

    // ========== Ω形 ==========
    Transform(
      from: Shapes.omega,
      to: Shapes.mirrorOf(Shapes.omega),
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 100, dir2: MotorDir.reversal, time2: 100),
      ],
      note: 'Ω形 → 镜像',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.omega),
      to: Shapes.omega,
      cmds: [
        MotorCmd(dir1: MotorDir.reversal, time1: 100, dir2: MotorDir.forward, time2: 100),
      ],
      note: 'Ω形镜像 → 原状',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.omega),
      to: Shapes.pentagon,
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 95, dir2: MotorDir.reversal, time2: 85),
      ],
      note: 'Ω形镜像 → 五边形',
      tag: 'game',
    ),

    // ========== 五边形 ==========
    Transform(
      from: Shapes.pentagon,
      to: Shapes.mirrorOf(Shapes.pentagon),
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 100, dir2: MotorDir.reversal, time2: 100),
      ],
      note: '五边形 → 镜像',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.pentagon),
      to: Shapes.pentagon,
      cmds: [
        MotorCmd(dir1: MotorDir.reversal, time1: 100, dir2: MotorDir.forward, time2: 100),
      ],
      note: '五边形镜像 → 原状',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.pentagon),
      to: Shapes.smile,
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 105, dir2: MotorDir.forward, time2: 75),
      ],
      note: '五边形镜像 → 微笑形',
      tag: 'game',
    ),

    // ========== 微笑形 ==========
    Transform(
      from: Shapes.smile,
      to: Shapes.mirrorOf(Shapes.smile),
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 100, dir2: MotorDir.reversal, time2: 100),
      ],
      note: '微笑形 → 镜像',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.smile),
      to: Shapes.smile,
      cmds: [
        MotorCmd(dir1: MotorDir.reversal, time1: 100, dir2: MotorDir.forward, time2: 100),
      ],
      note: '微笑形镜像 → 原状',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.smile),
      to: Shapes.zigzag,
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 88, dir2: MotorDir.reversal, time2: 92),
      ],
      note: '微笑形镜像 → Z字形',
      tag: 'game',
    ),

    // ========== Z字形 ==========
    Transform(
      from: Shapes.zigzag,
      to: Shapes.mirrorOf(Shapes.zigzag),
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 100, dir2: MotorDir.reversal, time2: 100),
      ],
      note: 'Z字形 → 镜像',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.zigzag),
      to: Shapes.zigzag,
      cmds: [
        MotorCmd(dir1: MotorDir.reversal, time1: 100, dir2: MotorDir.forward, time2: 100),
      ],
      note: 'Z字形镜像 → 原状',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.zigzag),
      to: Shapes.cat,
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 93, dir2: MotorDir.forward, time2: 87),
      ],
      note: 'Z字形镜像 → 猫形',
      tag: 'game',
    ),

    // ========== 猫形 ==========
    Transform(
      from: Shapes.cat,
      to: Shapes.mirrorOf(Shapes.cat),
      cmds: [
        MotorCmd(dir1: MotorDir.forward, time1: 100, dir2: MotorDir.reversal, time2: 100),
      ],
      note: '猫形 → 镜像',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.cat),
      to: Shapes.cat,
      cmds: [
        MotorCmd(dir1: MotorDir.reversal, time1: 100, dir2: MotorDir.forward, time2: 100),
      ],
      note: '猫形镜像 → 原状',
      tag: 'mirror',
    ),
    Transform(
      from: Shapes.mirrorOf(Shapes.cat),
      to: Shapes.straight,
      cmds: [
        MotorCmd(dir1: MotorDir.reversal, time1: 90, dir2: MotorDir.reversal, time2: 90),
      ],
      note: '猫形镜像 → 直线（循环）',
      tag: 'game',
    ),
  ];

  // ==================== 查询方法 ====================

  /// 查找变换
  static Transform? find(String from, String to) {
    for (final t in all) {
      if (t.from == from && t.to == to) return t;
    }
    return null;
  }

  /// 根据ID查找
  static Transform? findById(String id) {
    for (final t in all) {
      if (t.id == id) return t;
    }
    return null;
  }

  /// 获取某形状的所有变换
  static List<Transform> getForShape(String shape) {
    return all.where((t) => t.from == shape || t.to == shape).toList();
  }

  /// 获取某形状的镜像变换
  static List<Transform> getMirrorTransforms(String shape) {
    final normal = shape;
    final mirror = Shapes.mirrorOf(shape);
    return all.where((t) => 
      (t.from == normal && t.to == mirror) ||
      (t.from == mirror && t.to == normal)
    ).toList();
  }

  /// 获取游戏完整序列（8种形状循环）
  static List<Transform> getGameSequence() {
    final List<Transform> sequence = [];
    
    for (int i = 0; i < Shapes.all.length; i++) {
      final current = Shapes.all[i];
      final currentMirror = Shapes.mirrorOf(current);
      
      // 正常 → 镜像
      final toMirror = find(current, currentMirror);
      if (toMirror != null) sequence.add(toMirror);
      
      // 镜像 → 下一个（或回到第一个）
      final String next;
      if (i < Shapes.all.length - 1) {
        next = Shapes.all[i + 1];
      } else {
        next = Shapes.all[0];
      }
      
      final toNext = find(currentMirror, next);
      if (toNext != null) sequence.add(toNext);
    }
    
    return sequence;
  }

  /// 获取指定形状的序列（从该形状开始）
  static List<Transform> getSequenceFrom(String startShape) {
    final allShapes = Shapes.all;
    final startIndex = allShapes.indexOf(Shapes.baseOf(startShape));
    if (startIndex < 0) return [];

    final List<Transform> sequence = [];
    final isStartMirror = Shapes.isMirror(startShape);

    for (int i = 0; i < allShapes.length; i++) {
      final idx = (startIndex + i) % allShapes.length;
      final current = allShapes[idx];
      final currentMirror = Shapes.mirrorOf(current);

      // 第一个形状特殊处理
      if (i == 0) {
        if (isStartMirror) {
          // 从镜像开始，先镜像→正常，再正常→下一个
          final toNormal = find(currentMirror, current);
          if (toNormal != null) sequence.add(toNormal);
          
          final nextIdx = (idx + 1) % allShapes.length;
          final next = allShapes[nextIdx];
          final toNext = find(current, Shapes.mirrorOf(next));
          if (toNext != null) sequence.add(toNext);
        }
        continue;
      }

      // 正常 → 镜像
      final toMirror = find(current, currentMirror);
      if (toMirror != null) sequence.add(toMirror);

      // 镜像 → 下一个
      final nextIdx = (idx + 1) % allShapes.length;
      final next = allShapes[nextIdx];
      final toNext = find(currentMirror, next);
      if (toNext != null) sequence.add(toNext);
    }

    return sequence;
  }

  /// 按标签筛选
  static List<Transform> getByTag(String tag) {
    return all.where((t) => t.tag == tag).toList();
  }

  /// 获取所有镜像变换
  static List<Transform> getAllMirrorTransforms() {
    return all.where((t) => t.isMirrorTransform).toList();
  }

  /// 获取所有跨形状变换
  static List<Transform> getAllCrossTransforms() {
    return all.where((t) => t.isCrossTransform).toList();
  }

  /// 检查变换是否存在
  static bool exists(String from, String to) {
    return find(from, to) != null;
  }

  /// 获取缺失的变换
  static List<String> getMissingTransforms() {
    final missing = <String>[];
    
    // 检查所有镜像变换
    for (final shape in Shapes.all) {
      final normal = shape;
      final mirror = Shapes.mirrorOf(shape);
      
      if (!exists(normal, mirror)) {
        missing.add('$normal → $mirror');
      }
      if (!exists(mirror, normal)) {
        missing.add('$mirror → $normal');
      }
    }
    
    // 检查游戏流程变换
    for (int i = 0; i < Shapes.all.length; i++) {
      final current = Shapes.all[i];
      final currentMirror = Shapes.mirrorOf(current);
      final next = Shapes.all[(i + 1) % Shapes.all.length];
      
      if (!exists(currentMirror, next)) {
        missing.add('$currentMirror → $next (游戏流程)');
      }
    }
    
    return missing;
  }

  /// 生成配置代码（用于复制粘贴）
  static String generateConfigCode() {
    final buffer = StringBuffer();
    buffer.writeln('/// 形状变换配置');
    buffer.writeln('static const List<Transform> all = [');
    
    for (final t in all) {
      buffer.writeln();
      buffer.writeln(t.toCodeString());
    }
    
    buffer.writeln('];');
    return buffer.toString();
  }
}
