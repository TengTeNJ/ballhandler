import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'dart:isolate';

import 'package:code/utils/blue_tooth_manager.dart';
void playLocalAudio(String sourceName,{double volume = 0.2}) async {
  final player = AudioPlayer();

  // player.setSource(AssetSource('audio/${sourceName}'));
  await player.play(AssetSource('audio/${sourceName}'),volume: volume);
  //await player.resume();
}

void playRedAudio({String audioName = 'red1.mp3' }){
  if(BluetoothManager().redPlayer.state == PlayerState.playing){
    BluetoothManager().redPlayer.stop();
    Future.delayed(Duration(milliseconds: 100),(){
      BluetoothManager().redPlayer.play(AssetSource('audio/${audioName}'),volume: 1.0);
    });
  }else{
    BluetoothManager().redPlayer.play(AssetSource('audio/${audioName}'),volume: 1.0);
  }
}

void playBlueAudio({String audioName = 'blue1.mp3' }){
  if(BluetoothManager().bluePlayer.state == PlayerState.playing){
    BluetoothManager().bluePlayer.stop();
    Future.delayed(Duration(milliseconds: 100),(){
      BluetoothManager().bluePlayer.play(AssetSource('audio/${audioName}'),volume: 1.0);
    });
  }else{
    BluetoothManager().bluePlayer.play(AssetSource('audio/${audioName}'),volume: 1.0);
  }
}
/*预加载音频资源 防止首次播放时有延迟*/
void preLoadAudioAsset() async{
  // final player = AudioPlayer();
  // await player.setSource(AssetSource('audio/start.mp3}'));
  // await player.setSource(AssetSource('audio/end.mp3}'));
  // await player.setSource(AssetSource('audio/red.mp3}'));
  // await player.setSource(AssetSource('audio/blue.mp3}'));
  //
  // // 创建AudioCache实例
  // final audioCache = AudioCache();
  // audioCache.load('sound_a.mp3').then((player) {
  //   // 音频加载成功
  // });
  // audioCache.load('sound_b.mp3').then((player) {
  //   // 音频加载成功
  // });
}
//
// class AudioPlayerUtil {
//   static const String _isolateName = 'audio_player_isolate';
//
//   // 用于从Isolate发送消息回主线程的SendPort
//   SendPort? _sendPort;
//
//   // 用于接收Isolate消息的ReceivePort
//   ReceivePort _receivePort = ReceivePort();
//
//   // 初始化方法，设置Isolate并监听消息
//   AudioPlayerUtil() {
//     _receivePort.listen((message) {
//       if (message is SendPort) {
//         _sendPort = message;
//       } else if (message == 'play') {
//         _playAudio();
//       }
//     });
//
//     // 启动Isolate
//     IsolateNameServer.registerPortWithName(_receivePort.sendPort, _isolateName);
//     Isolate.spawn(_isolateEntryPoint, _isolateName);
//   }
//
//   // 外部调用的方法，用于播放音频
//   Future<void> playAudio(String url) async {
//     if (_sendPort != null) {
//       _sendPort!.send(url);
//     } else {
//       throw Exception('Isolate has not been initialized yet.');
//     }
//   }
//
//   // Isolate中的入口点
//   static void _isolateEntryPoint(String isolateName, SendPort replyTo) {
//     final ReceivePort receivePort = ReceivePort();
//     replyTo.send(receivePort.sendPort);
//
//     receivePort.listen((message) {
//       if (message is String) {
//         _playAudioInIsolate(message);
//       }
//     });
//   }
//
//   // 在Isolate中播放音频的方法
//   static void _playAudioInIsolate(String url) {
//     final player = AudioPlayer();
//     player.setUrl(url).then((_) {
//       player.play();
//     }).catchError((error) {
//       print('Error playing audio: $error');
//     });
//   }
//
//   // 播放音频的方法（在Isolate中调用）
//   void _playAudio() {
//     // 这里可以添加播放逻辑，例如从某个变量获取URL
//   }
// }
