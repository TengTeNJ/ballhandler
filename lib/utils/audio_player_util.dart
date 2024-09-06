import 'package:audioplayers/audioplayers.dart';
void playLocalAudio(String sourceName,{double volume = 0.2}) async {
  final player = AudioPlayer();
  // player.setSource(AssetSource('audio/${sourceName}'));
  await player.play(AssetSource('audio/${sourceName}'),volume: volume);
  //await player.resume();
}