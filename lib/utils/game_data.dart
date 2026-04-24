class GameData {
  int score;
  int countdown;
  int lights;

  GameData({
    this.score = 0,
    this.countdown = 0,
    this.lights  = 0,
  });

  GameData copyWith({
    int? score,
    int? countdown,
    int? lights,
  }) {
    return GameData(
      score: score ?? this.score,
      countdown: countdown ?? this.countdown,
      lights:  lights ?? this.lights
    );
  }
}