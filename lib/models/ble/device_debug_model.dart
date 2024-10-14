class DeviceDebugModel {
  int channel = 0; // 信道
  int interferenceLevel = 2; //  干扰容错级别
  int autooffTime = 1200000; // 自动关机时间
  bool debugSwitch = false; //  debug开关
  bool btSwitch = false; //  bt自动断连开关
  bool preSwitch = false; //  321 pre开关
  int longPressCheckSwitch = 1; //  长按检测功能选择；数据1字节：0x00: 关闭；0x01: 打开工厂模式；0x02: 打开用户模式；缺省：0x01
  String bltName = ''; // 蓝牙名称
  String bltMac = ''; // 蓝牙MAC地址
  String get autoOffRemainString{
  // 自动关机剩余时间
  int second = (this.autooffTime/ 1000).floor() as int ;
  int minute = (second / 60).floor() as int ;
  int remainingSeconds = second % 60; // 获取秒数
  return '$minute分:${remainingSeconds.toString().padLeft(2, '0')}秒'; // 格式化为 'mm:ss'
}
  String get longPressCheckText{
   if(longPressCheckSwitch == 0){
     return '关闭';
   }else if(longPressCheckSwitch == 1){
     return '打开工厂模式';
   }else if(longPressCheckSwitch == 2){
     return '打开用户模式';
   }
   return '打开工厂模式';
  }
}
