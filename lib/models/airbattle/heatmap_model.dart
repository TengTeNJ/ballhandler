enum HeatMapStatu {
  Zero, // 无数据 0次
  Primary, // 初级 1-2次
  Middle, // 中等 3-4次
  Active, // 活跃 5次
}

class HeatMapDataModel {
  int count = 0; // 训练次数
  HeatMapDataModel({ required this.count});
  HeatMapStatu get statu {
    if (this.count  >0 && this.count <= 2) {
      return HeatMapStatu.Primary;
    } else if (this.count >= 3 && this.count <= 4) {
      return HeatMapStatu.Middle;
    } else if (this.count >= 5) {
      return HeatMapStatu.Active;
    }
    return HeatMapStatu.Zero;
  }
}
