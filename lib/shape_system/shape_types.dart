/// 8种基础形状定义
enum BaseShape {
  straightLine,  // 直线
  shape2,        // 2字形
  lShape,        // L形
  omega,         // Ω形
  pentagon,      // 五边形
  smile,         // 微笑形
  zigzag,        // Z字形
  cat,           // 猫形
}

/// 形状扩展方法
extension BaseShapeExtension on BaseShape {
  /// 形状显示名称
  String get displayName {
    switch (this) {
      case BaseShape.straightLine:
        return '直线';
      case BaseShape.shape2:
        return '2字形';
      case BaseShape.lShape:
        return 'L形';
      case BaseShape.omega:
        return 'Ω形';
      case BaseShape.pentagon:
        return '五边形';
      case BaseShape.smile:
        return '微笑形';
      case BaseShape.zigzag:
        return 'Z字形';
      case BaseShape.cat:
        return '猫形';
    }
  }

  /// 形状英文名称（用于存储）
  String get key {
    switch (this) {
      case BaseShape.straightLine:
        return 'straight_line';
      case BaseShape.shape2:
        return 'shape_2';
      case BaseShape.lShape:
        return 'l_shape';
      case BaseShape.omega:
        return 'omega';
      case BaseShape.pentagon:
        return 'pentagon';
      case BaseShape.smile:
        return 'smile';
      case BaseShape.zigzag:
        return 'zigzag';
      case BaseShape.cat:
        return 'cat';
    }
  }

  /// 从key解析
  static BaseShape? fromKey(String key) {
    for (final shape in BaseShape.values) {
      if (shape.key == key) return shape;
    }
    return null;
  }
}

/// 形状状态（是否镜像）
enum ShapeOrientation {
  normal,  // 正常
  mirrored, // 镜像
}

extension ShapeOrientationExtension on ShapeOrientation {
  String get displayName {
    switch (this) {
      case ShapeOrientation.normal:
        return '正常';
      case ShapeOrientation.mirrored:
        return '镜像';
    }
  }

  String get suffix {
    switch (this) {
      case ShapeOrientation.normal:
        return '';
      case ShapeOrientation.mirrored:
        return '_mirror';
    }
  }
}

/// 完整的形状标识（形状类型 + 是否镜像）
class ShapeId {
  final BaseShape shape;
  final ShapeOrientation orientation;

  const ShapeId({
    required this.shape,
    this.orientation = ShapeOrientation.normal,
  });

  /// 获取镜像版本
  ShapeId get mirrored => ShapeId(
        shape: shape,
        orientation: orientation == ShapeOrientation.normal
            ? ShapeOrientation.mirrored
            : ShapeOrientation.normal,
      );

  /// 是否镜像
  bool get isMirrored => orientation == ShapeOrientation.mirrored;

  /// 唯一标识key
  String get key => '${shape.key}${orientation.suffix}';

  /// 显示名称
  String get displayName => '${shape.displayName}${isMirrored ? "(镜像)" : ""}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShapeId && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => 'ShapeId($displayName)';
}
