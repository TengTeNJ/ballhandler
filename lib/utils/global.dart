enum GameScene {
  five,
  threee,
  erqiling
}

class GameUtil {
  GameScene gameScene = GameScene.five; // 默认为五节控球器
  int modelId = 6; // 场景下对应的模式模式
  bool nowISGamePage = false; // 是否在游戏页面，如果不在，收到了蓝牙的响应数据则不处理
  bool selectRecord = false; // 是否选择录制视频
}