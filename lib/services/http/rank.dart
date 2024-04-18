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
            !ISEmpty(_map['country']) ? _map['country'].toString() : 'China';
        model.trainVideo =
            !ISEmpty(_map['trainVideo']) ? _map['trainVideo'].toString() : '';
        _list.add(model);
      });
      _model.data = _list;
      return ApiResponse(success: response.success, data: _model);
    } else {
      return ApiResponse(success: false);
    }
  }

  /*折线图数据*/
  static Future<ApiResponse<List<MyStatsModel>>> queryLineViewData(String? startTime, String? endTime) async {
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
}
