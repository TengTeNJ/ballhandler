import 'package:flutter/foundation.dart';
import 'game_data.dart';

class GameDataBus {
  static final GameDataBus instance = GameDataBus._();

  GameDataBus._();

  /// 整体状态（推荐）
  final ValueNotifier<GameData> gameData =
  ValueNotifier(GameData());

  /// 单独字段（给高频UI用）
  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<int> countdown = ValueNotifier(0);

  /// 更新（核心方法）
  void updateScoreAndTime(int newScore, int newCountdown) {
    final old = gameData.value;

    // 👉 去重（防止UI疯狂刷新）
    if (old.score == newScore && old.countdown == newCountdown) {
      return;
    }

    // 👉 更新整体数据
    final newData = old.copyWith(
      score: newScore,
      countdown: newCountdown,
    );

    gameData.value = newData;

    // 👉 更新局部字段（给UI用）
    if (score.value != newScore) {
      score.value = newScore;
    }

    if (countdown.value != newCountdown) {
      countdown.value = newCountdown;
    }
  }

  /// 重置（开始新一局时用）
  void reset() {
    gameData.value = GameData();
    score.value = 0;
    countdown.value = 0;
  }
}