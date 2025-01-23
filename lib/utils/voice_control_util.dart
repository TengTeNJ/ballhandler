import 'package:code/utils/audio_player_util.dart';

class VoiceControlUtil {
  // 私有构造函数
  VoiceControlUtil._internal();

  // 静态实例
  static final VoiceControlUtil _instance = VoiceControlUtil._internal();

  // 公开的静态方法获取实例
  static VoiceControlUtil get instance => _instance;

  factory VoiceControlUtil() {
    return _instance;
  }

  // 连续红灯击中次数
  int redConsecutiveTimes = 0;
  // 连续蓝灯次数
  int blueConsecutiveTimes = 0;
  // 上一次击中红灯的时间
  DateTime? lastRedDateTime;
  // 上一次击中蓝灯的时间
  DateTime? lastBlueDateTime;

  // 击中红灯
  void redHitHandle() {
    if(redConsecutiveTimes == 0){
      // 代表是首次击中
      redConsecutiveTimes++;
    }else{
      DateTime dateTime = DateTime.now();
      final Duration duration = dateTime.difference(lastRedDateTime!);
      // 计算时间差 单位为毫秒
      int different = duration.inMilliseconds;
      print('different = ${different}');
      if(different >2000){
        redConsecutiveTimes = 1;
      }else{
        redConsecutiveTimes ++;
      }
    }
    if(redConsecutiveTimes  == 1){
      playRedAudio(audioName: 'red1.mp3');
      print('red1--');
    }else if(redConsecutiveTimes  == 2 || redConsecutiveTimes  == 3){
      playRedAudio(audioName: 'red2.mp3');
      print('red2--');
    }else if(redConsecutiveTimes >= 4){
      playRedAudio(audioName: 'red3.wav');
      print('red4--');
    }else{
      playRedAudio(audioName: 'red1.mp3');
      print('--red1--');
    }
    lastRedDateTime = DateTime.now();
  }
  // 击中蓝灯
  void blueHitHandle() {
    if(blueConsecutiveTimes == 0){
      // 代表是首次击中
      blueConsecutiveTimes++;
    }else{
      DateTime dateTime = DateTime.now();
      final Duration duration = dateTime.difference(lastBlueDateTime!);
      // 计算时间差 单位为毫秒
      int different = duration.inMilliseconds;
      if(different >2000){
        blueConsecutiveTimes = 1;
      }else{
        blueConsecutiveTimes ++;
      }
    }
    if(blueConsecutiveTimes  == 1){
      playRedAudio(audioName: 'blue1.mp3');
    }else if(blueConsecutiveTimes  == 2){
      playRedAudio(audioName: 'blue2.mp3');
    }else if(blueConsecutiveTimes >= 3){
      playRedAudio(audioName: 'blue3.mp3');
    }else{
      playRedAudio(audioName: 'blue1.mp3');
    }
    lastBlueDateTime = DateTime.now();
  }

  void reset(){
    redConsecutiveTimes = 0;
    blueConsecutiveTimes = 0;
    lastRedDateTime = null;
    lastBlueDateTime = null;
  }
}