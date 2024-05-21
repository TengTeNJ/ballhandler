import 'package:code/models/mystats/my_stats_model.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/string_util.dart';
import 'package:get_it/get_it.dart';
import '../../constants/constants.dart';
import '../../utils/global.dart';

class RankModel {
  String? rankNumber;
  String? avgPace;
  String? nickName;
  String? avatar;
  String? country;
  String trainVideo = '';
  String trainScore = '0';
  String createTime = '';
  String modeId = '';
  String sceneId = '';
}

const int compareLength = 3;

class AnalyzeDataModel{
  dynamic avgPace = 0;
  dynamic trainCount = 0;
  dynamic trainScore = 0;
  dynamic trainTime = 0;
  dynamic lastAvgPace = 0;
  dynamic lastTrainCount = 0;
  dynamic lastTrainScore = 0;
  dynamic lastTrainTime = 0;
  String rankNumber = '-';
  // 速度对比
  String get avgPaceCompared {
    if(this.avgPace == 0 || this.lastAvgPace == 0){
      return '-';
    }
    bool rise = (this.avgPace - this.lastAvgPace) < 0; // 速度越小 成绩越好
    double comparedValue = (this.avgPace - this.lastAvgPace).abs()/this.lastAvgPace;
    String somparedString = convertToPercentage(comparedValue);
    if(somparedString.length >compareLength){
      somparedString = somparedString.substring(0,compareLength);
    }
    if(somparedString.lastIndexOf('.') > 0){
      somparedString = somparedString.replaceAll('.', '');
    }
    print('somparedString=${somparedString}');
    return (rise ?('+' + somparedString): ('-' + somparedString)) + '%' ;
  }
  bool get avgRise {
    bool rise = (this.avgPace - this.lastAvgPace) < 0;
   return rise;
  }

  // 得分对比
  String get scoreCompared {
    if(this.trainScore == 0 || this.lastTrainScore == 0){
      return '-';
    }
    bool rise = (this.trainScore - this.lastTrainScore) > 0;
    double comparedValue = (this.trainScore - this.lastTrainScore).abs()/this.lastTrainScore;
    String somparedString = convertToPercentage(comparedValue);
    if(somparedString.length >compareLength){
      somparedString = somparedString.substring(0,compareLength);
    }
    print('somparedString.lastIndexOf(\'.\')=${somparedString.lastIndexOf('.')}');
    if(somparedString.lastIndexOf('.') >0){
      somparedString = somparedString.replaceAll('.', '');
    }
    return (rise ?('+' + somparedString): ('-' + somparedString)) + '%' ;
  }
  bool get scoreRise {
    bool rise = (this.trainScore - this.lastTrainScore) > 0;
    return rise;
  }
// 时间对比
  String get timeCompared {
    if(this.trainTime == 0 || this.lastTrainTime == 0){
      return '-';
    }
    bool rise = (this.trainTime - this.lastTrainTime) > 0;
    double comparedValue = (this.trainTime - this.lastTrainTime).abs()/this.lastTrainTime;
    String somparedString = convertToPercentage(comparedValue);
    if(somparedString.length >compareLength){
      somparedString = somparedString.substring(0,compareLength);
    }
    if(somparedString.lastIndexOf('.') >0){
      somparedString = somparedString.replaceAll('.', '');
    }
    return (rise ?('+' + somparedString): ('-' + somparedString)) + '%' ;
  }
  bool get timeRise {
    bool rise = (this.trainTime - this.lastTrainTime) > 0;
    return rise;
  }

  // 次数对比
  String get countCompared {
    if(this.trainCount == 0 || this.lastTrainCount == 0){
      return '-';
    }
    bool rise = (this.trainCount - this.lastTrainCount) > 0;
    double comparedValue = (this.trainCount - this.lastTrainCount).abs()/this.lastTrainCount;
    String somparedString = convertToPercentage(comparedValue);
    if(somparedString.length >compareLength){
      somparedString = somparedString.substring(0,compareLength);
    }
    if(somparedString.lastIndexOf('.') >0){
      somparedString = somparedString.replaceAll('.', '');
    }
    return (rise ?('+' + somparedString): ('-' + somparedString)) + '%' ;
  }
  bool get countRise {
    bool rise = (this.trainCount - this.lastTrainCount) > 0;
    return rise;
  }
}

String convertToPercentage(double value) {
  String percentValue = (value * 100).toStringAsFixed(2);
  String _temp = formatNumber(double.parse(percentValue));
  return '${_temp}';
}

String formatNumber(double number) {
  if (number >= 100) {
    return number.toInt().toString();
  } else if (number >= 10) {
    return number.toStringAsFixed(1);
  } else {
    return number.toStringAsFixed(2);
  }
}

class RankListModel {
  List<RankModel> data = [];
  int count = 0;
}

class Rank {
  //*查询排名列表*/
  static Future<ApiResponse<RankListModel>> queryRankListData(int page) async {
    // 获取场景ID
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    final _data = {
      "limit": kPageLimit.toString(),
      "page": page.toString(),
      "sceneId": (gameUtil.gameScene.index + 1).toString(),
    };
    final response = await HttpUtil.get('/api/statistic/rankList', _data,
        showLoading: false);
    RankListModel _model = RankListModel();
    List<RankModel> _list = [];
    if (response.success && response.data['data'] != null) {
      final _count = response.data['count'];
      _model.count = _count;
      final _array = response.data['data'] as List;
      _array.forEach((element) {
        RankModel model = RankModel();
        final _map = element;
        model.avgPace =
            !ISEmpty(_map['avgPace']) ? _map['avgPace'].toString() : '--';
        model.rankNumber =
            !ISEmpty(_map['rankNumber']) ? _map['rankNumber'].toString() : '--';
        model.nickName =
            !ISEmpty(_map['nickName']) ? _map['nickName'].toString() : '--';
        model.avatar =
            !ISEmpty(_map['avatar']) ? _map['avatar'].toString() : '';
        model.country =
            !ISEmpty(_map['country']) ? _map['country'].toString() : '--';
        model.trainVideo =
            !ISEmpty(_map['trainVideo']) ? _map['trainVideo'].toString() : '';
        model.trainScore =
        !ISEmpty(_map['trainScore']) ? _map['trainScore'].toString() : '-';
        model.createTime =
        !ISEmpty(_map['createTime']) ? _map['createTime'].toString() : '-';
        model.sceneId =
        !ISEmpty(_map['sceneId']) ? _map['sceneId'].toString() : '1';
        model.modeId =
        !ISEmpty(_map['modeId']) ? _map['modeId'].toString() : '1';
        _list.add(model);
      });
      _model.data = _list;
      return ApiResponse(success: response.success, data: _model);
    } else {
      return ApiResponse(success: false);
    }
  }

  /*折线图数据*/
  static Future<ApiResponse<List<MyStatsModel>>> queryLineViewData(String? startTime, String? endTime,{bool isWeek = false}) async {
    // 获取场景ID
    GameUtil gameUtil = GetIt.instance<GameUtil>();

    DateTime _selectedDate = DateTime.now();
    DateTime yesterday = _selectedDate.subtract(Duration(days: 1));
    DateTime  _yesterdayDate = yesterday;
    String _endTimer = StringUtil.dateTimeToString(yesterday);
    // 过去七天的第一天的时间
    DateTime beforeSeven = yesterday.subtract(Duration(days: 7));
    String  _startTime = StringUtil.dateTimeToString(beforeSeven);
    if(startTime == null){
      startTime = _endTimer ;
    }
    if(endTime == null){
      endTime = _startTime;
    }

    final _data = {
      "sceneId": (gameUtil.gameScene.index + 1).toString(),
      "endDate": startTime,
      "startDate": endTime};
    final response = await HttpUtil.get('/api/statistic/trainLine', _data,
        showLoading: false);
    List<MyStatsModel> _list = [];
    List<String> _weekText = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List;
      _array.forEach((element) {
        MyStatsModel model = MyStatsModel();
        final _map = element;
        model.gameTimer =
            !ISEmpty(_map['createTime']) ? _map['createTime'].toString() : '--';
        model.speed = !ISEmpty(_map['avgPace']) ? _map['avgPace'] : 0;
        model.sceneId = !ISEmpty(_map['sceneId']) ? _map['sceneId'].toString() : '1';
        model.modeId = !ISEmpty(_map['modeId']) ? _map['modeId'].toString() : '1';
        model.rank =
            !ISEmpty(_map['rankNumber']) ? _map['rankNumber'].toString() : '--';
        model.indexString = (_array.indexOf(element) + 1).toString();
        _list.add(model);
      });
      return ApiResponse(success: response.success, data: _list);
    } else {
      return ApiResponse(success: false);
    }
  }

  /*查询历史20条最好成绩的排名和速度*/
  static Future<ApiResponse<List<MyStatsModel>>> queryBarViewData() async {
    // 获取场景ID
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    final _data = {
      "sceneId": (gameUtil.gameScene.index + 1).toString(),
      "endDate": StringUtil.dateToString(DateTime.now()),
      "startDate": "2024-04-01" // 该接口取的是历史以来的最高的二十条数据 保证开始时间早于上线或者最初调试时间
    };
    final response = await HttpUtil.get('/api/statistic/trainBar', _data,
        showLoading: false);
    List<MyStatsModel> _list = [];
    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List;
      _array.forEach((element) {
        MyStatsModel model = MyStatsModel();
        final _map = element;
        model.gameTimer =
            !ISEmpty(_map['createTime']) ? _map['createTime'].toString() : '--';
        model.speed = !ISEmpty(_map['avgPace']) ? _map['avgPace'] : 0;
        model.rank =
            !ISEmpty(_map['rankNumber']) ? _map['rankNumber'].toString() : '--';
        model.indexString = (_array.indexOf(element) + 1).toString();
        _list.add(model);
      });
      return ApiResponse(success: response.success, data: _list);
    } else {
      return ApiResponse(success: false);
    }
  }

  /*请求分析数据*/
  static Future<ApiResponse<AnalyzeDataModel>> queryComparetData(String? startDate,String? endDate,String selectType) async {

    DateTime _selectedDate = DateTime.now();
    DateTime yesterday = _selectedDate.subtract(Duration(days: 1));
    DateTime  _yesterdayDate = yesterday;
    String _endTimer = StringUtil.dateTimeToString(yesterday);
    // 过去七天的第一天的时间
    DateTime beforeSeven = yesterday.subtract(Duration(days: 7));
    String  _startTime = StringUtil.dateTimeToString(beforeSeven);
    if(startDate == null){
      startDate = _endTimer ;
    }
    if(endDate == null){
      endDate = _startTime;
    }
    // 获取场景ID
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    final _data = {
      "startDate": endDate,
      "endDate":startDate,
      "selectType":selectType,
      "sceneId": (gameUtil.gameScene.index + 1).toString(),
    };
    final response = await HttpUtil.get('/api/statistic/trainData', _data,
        showLoading: false);
    AnalyzeDataModel _model = AnalyzeDataModel();

    if (response.success && response.data['data'] != null) {
      final _map = response.data['data'];
      _model.trainCount =
      !ISEmpty(_map['trainCount']) ? _map['trainCount'] : 0;
      _model.lastTrainCount =
      !ISEmpty(_map['lastTrainCount']) ? _map['lastTrainCount'] : 0;
      _model.trainTime =
      !ISEmpty(_map['trainTime']) ? _map['trainTime'] : 0;
      _model.lastTrainTime =
      !ISEmpty(_map['lastTrainTime']) ? _map['lastTrainTime'] : 0;
      _model.trainScore =
      !ISEmpty(_map['trainScore']) ? _map['trainScore'] : 0;
      _model.lastTrainScore =
      !ISEmpty(_map['lastTrainScore']) ? _map['lastTrainScore'] : 0;
      _model.avgPace =
      !ISEmpty(_map['avgPace']) ? _map['avgPace'] : 0;
      _model.lastAvgPace =
      !ISEmpty(_map['lastAvgPace']) ? _map['lastAvgPace'] : 0;
      _model.rankNumber =
      !ISEmpty(_map['rankNumber']) ? _map['rankNumber'].toString() : '-';
      return ApiResponse(success: response.success, data: _model);
    } else {
      return ApiResponse(success: false);
    }
  }

}
