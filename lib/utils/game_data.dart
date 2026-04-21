class GameData {
  int score;
  int countdown;

  GameData({
    this.score = 0,
    this.countdown = 0,
  });

  GameData copyWith({
    int? score,
    int? countdown,
  }) {
    return GameData(
      score: score ?? this.score,
      countdown: countdown ?? this.countdown,
    );
  }
}