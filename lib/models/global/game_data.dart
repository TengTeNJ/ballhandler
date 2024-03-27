
class GameData  {
  bool _powerOn = false; // 开机状态
  int _currentTarget = 0; // 当前响应标靶
  int _score = 0; // 得分
  bool _gameStart = false; // 游戏状态
  int _powerValue = 100; // 电量值
  int _remainTime = 45; // 剩余时长
  String _showRemainTime = '00:45'; // 需要在UI上显示的剩余时长的格式
  /* get方法 */
  bool get powerOn => _powerOn;
  int get currentTarget => _currentTarget;
  int get score => _score;
  int get powerValue => _powerValue;
  bool get gameStart => _gameStart;
  int get remainTime => _remainTime;
  String get showRemainTime => _showRemainTime;
  /* set方法*/
  set powerOn(bool powerOn){
    _powerOn = powerOn;
  }

  set currentTarget(int currentTarget){
    _currentTarget = currentTarget;
  }

  set score(int score){
    _score = score;
  }

  set powerValue(int powerValue){
    _powerValue = powerValue;
  }

  set gameStart(bool gameStart){
    _gameStart = gameStart;
  }

  set remainTime(int remainTime){
    _remainTime = remainTime;
    // 自动处理显示的剩余时长格字符串
    _showRemainTime =  '00:' + _remainTime.toString().padLeft(2, '0');
  }

}

