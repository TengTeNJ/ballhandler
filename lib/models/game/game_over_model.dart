import 'package:json_annotation/json_annotation.dart';

part 'game_over_model.g.dart';

@JsonSerializable()
class GameOverModel {
  String time = '00:45';
  String score = '0';
  String avgPace = '0.0';
  String rank = '-';
  String endTime = 'Mar 31.2024 10.30';
  String? videoPath = ''; //  视频路径
  String Integral = '1'; // 积分，默认为1
  factory GameOverModel.fromJson(Map<String, dynamic> json) =>
      _$GameOverModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameOverModelToJson(this);

  GameOverModel(
      {required this.time,
      required this.score,
      required this.avgPace,
      required this.rank,
      required this.endTime,
       this.videoPath});
}
