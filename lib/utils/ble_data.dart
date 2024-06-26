List<int> onLineData(){
  print('online---data');
  int v = 0xA5 + 0x07 + 0x022 + 0x01 + 0x01;
  List<int> values = [0xA5,0x07,0x22,0x01,0x01,v,0xAA];
  print('values=${values}');
  return values;
}
List<int> heartBeatData(){
  int v = 0xA5 + 0x05 + 0x30;
  List<int> values = [0xA5,0x05,0x30,v,0xAA];
  return values;
}
List<int> openAllBlueLightData(){
  int v = 0xA5 + 0x06 + 0x01 + 0x81;
  List<int> values = [0xA5,0x06,0x01,0x81,v,0xAA];
  return values;
}

List<int> milleEnableData(){
  int v = 0xA5 + 0x06 + 0x34 + 0x01;
  List<int> values = [0xA5,0x06,0x34,0x01,v,0xAA];
  return values;
}

List<int> questDeviceInfoData(){
  int v = 0xA5 + 0x05 + 0x36;
  List<int> values = [0xA5,0x05,0x36,v,0xAA];
  return values;
}