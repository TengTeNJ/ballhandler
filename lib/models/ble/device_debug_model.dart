class DeviceDebugModel {
  int channel = 0; // 信道
  int interferenceLevel = 2; //  干扰容错级别
  int autooffTime = 1200000; // 自动关机时间
  bool debugSwitch = false; //  debug开关
  bool btSwitch = false; //  bt自动断连开关
  bool preSwitch = false; //  321 pre开关
 String get autoOffRemainString{
  // 自动关机剩余时间
  int second = (this.autooffTime/ 1000).floor() as int ;
  int minute = (second / 60).floor() as int ;
  int remainingSeconds = second % 60; // 获取秒数
  return '$minute分:${remainingSeconds.toString().padLeft(2, '0')}秒'; // 格式化为 'mm:ss'
  return '';
}
}
