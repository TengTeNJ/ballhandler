enum HeatMapStatu{
  Zero, // 无数据 0次
  Primary, // 初级 1-2次
  Middle, // 中等 3-4次
  Active, // 活跃 5次
}
class HeatMapModel{
  HeatMapStatu statu = HeatMapStatu.Zero;
  HeatMapModel({
    this.statu = HeatMapStatu.Zero
  });
}