// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_over_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameOverModel _$GameOverModelFromJson(Map<String, dynamic> json) =>
    GameOverModel(
      time: json['time'] as String,
      score: json['score'] as String,
      avgPace: json['avgPace'] as String,
      rank: json['rank'] as String,
      endTime: json['endTime'] as String,
      videoPath: json['videoPath'] as String?,
    );

Map<String, dynamic> _$GameOverModelToJson(GameOverModel instance) =>
    <String, dynamic>{
      'time': instance.time,
      'score': instance.score,
      'avgPace': instance.avgPace,
      'rank': instance.rank,
      'endTime': instance.endTime,
      'videoPath': instance.videoPath,
    };
