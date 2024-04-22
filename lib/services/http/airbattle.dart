import 'package:code/utils/http_util.dart';
import 'package:code/utils/string_util.dart';
import '../../constants/constants.dart';

class MyActivityModel {
  String activityIcon = ''; // icon
  String activityId = ''; //  活动id
  String activityName = ''; // 活动名称
  String avgPace = ''; // 速度
  String endDate = ''; // 结束时间
  String rankNumber = ''; // 排名
  String startDate = ''; // 开始时间
  String trainScore = ''; // 得分
  String trainVideo = ''; // 视频链接
}

class AirBattleHomeModel {
  int activityAward = 0; // 获奖次数
  int activityCount = 0; // 参加活动的次数
  int activityIntegral = 0; // 活动得的积分
}

class ActivityModel {
  String activityBackground = ''; // 活动背景图
  String activityIcon = ''; // 活动图标
  int activityId = 0; // 活动编号
  String activityName = ''; // 活动名称
  String activityRemark = ''; //活动描述
  int activityStatus = 0; // 活动状态：0未开始 1正在进行 2已结束
  String endDate = ''; // 活动结束时间
  String startDate = ''; // 活动开始时间
  String get statuString {
    String tempString = 'Not started yet';
    if (this.activityStatus == 1) {
      tempString = 'Under Way';
    } else if (this.activityStatus == 2) {
      tempString = 'Already finished';
    }
    return tempString;
  }
}

class MessageModel{
   String createTime = ''; // 发送时间
   String messageDesc = ''; // 消息描述
   String messageTitle = '';
}

class AirBattle {
  static Future<ApiResponse<List<MyActivityModel>>> queryMyActivityData(
      int page) async {
    final _data = {
      "limit": kPageLimit.toString(),
      "page": page.toString(),
    };
    final response =
        await HttpUtil.get('/api/activity/myList', _data, showLoading: true);
    List<MyActivityModel> _list = [];

    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List;
      _array.forEach((element) {
        MyActivityModel model = MyActivityModel();
        final _map = element;
        model.avgPace =
            !ISEmpty(_map['avgPace']) ? _map['avgPace'].toString() : '--';
        model.rankNumber =
            !ISEmpty(_map['rankNumber']) ? _map['rankNumber'].toString() : '--';
        model.activityIcon = !ISEmpty(_map['activityIcon'])
            ? _map['activityIcon'].toString()
            : '--';
        model.activityId =
            !ISEmpty(_map['activityId']) ? _map['activityId'].toString() : '--';
        model.activityName = !ISEmpty(_map['activityName'])
            ? _map['activityName'].toString()
            : '--';

        model.endDate =
            !ISEmpty(_map['endDate']) ?StringUtil.serviceStringToShowDateString(_map['endDate'].toString()) : '--';
        model.startDate =
            !ISEmpty(_map['startDate']) ? StringUtil.serviceStringToShowDateString(_map['startDate'].toString()).toString() : '--';
        model.trainScore =
            !ISEmpty(_map['trainScore']) ? _map['trainScore'].toString() : '--';
        model.trainVideo =
            !ISEmpty(_map['trainVideo']) ? _map['trainVideo'].toString() : '--';
        _list.add(model);
      });
      return ApiResponse(success: response.success, data: _list);
    } else {
      return ApiResponse(success: false);
    }
  }

  /*查询所有的活动列表*/
  static Future<ApiResponse<List<ActivityModel>>> queryAllActivityListData(
      int page) async {
    final _data = {
      "limit": kPageLimit.toString(),
      "page": page.toString(),
    };
    final response =
        await HttpUtil.get('/api/activity/allList', _data, showLoading: true);
    List<ActivityModel> _list = [];

    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List;
      _array.forEach((element) {
        ActivityModel model = ActivityModel();
        final _map = element;
        model.activityBackground = !ISEmpty(_map['activityBackground'])
            ? _map['activityBackground'].toString()
            : '';
        model.activityIcon = !ISEmpty(_map['activityIcon'])
            ? _map['activityIcon'].toString()
            : '--';
        model.activityId =
            !ISEmpty(_map['activityId']) ? _map['activityId'] : 1;
        model.activityStatus =
            !ISEmpty(_map['activityStatus']) ? _map['activityStatus'] : 0;
        model.activityRemark = !ISEmpty(_map['activityRemark'])
            ? _map['activityRemark'].toString()
            : '--';
        model.endDate =
            !ISEmpty(_map['endDate']) ? StringUtil.serviceStringToShowDateString(_map['endDate'].toString()) : '--';
        model.startDate =
            !ISEmpty(_map['startDate']) ? StringUtil.serviceStringToShowDateString(_map['startDate'].toString()) : '--';
        model.activityName = !ISEmpty(_map['activityName'])
            ? _map['activityName'].toString()
            : '--';
        _list.add(model);
      });
      return ApiResponse(success: response.success, data: _list);
    } else {
      return ApiResponse(success: false);
    }
  }

/*查询参与AirBattle的数据*/
  static Future<ApiResponse<AirBattleHomeModel>> queryIAirBattleData() async {
    final response =
        await HttpUtil.get('/api/activity/index', null, showLoading: false);
    AirBattleHomeModel model = AirBattleHomeModel();
    if (response.success && response.data['data'] != null) {
      final element = response.data['data'];
      final _map = element;
      model.activityAward =
          !ISEmpty(_map['activityAward']) ? _map['activityAward'] : 0;
      model.activityCount =
          !ISEmpty(_map['activityCount']) ? _map['activityCount'] : 0;
      model.activityIntegral =
          !ISEmpty(_map['activityIntegral']) ? _map['activityIntegral'] : 0;
      return ApiResponse(success: response.success, data: model);
    } else {
      return ApiResponse(success: false);
    }
  }

  /*查询所有的消息列表*/
  static Future<ApiResponse<List<MessageModel>>> queryAllMessageListData(
      int page) async {
    final _data = {
      "limit": kPageLimit.toString(),
      "page": page.toString(),
    };
    final response =
    await HttpUtil.get('/api/message/list', _data, showLoading: true);
    List<MessageModel> _list = [];

    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List;
      _array.forEach((element) {
        MessageModel model = MessageModel();
        final _map = element;
        model.createTime = !ISEmpty(_map['createTime'])
            ? _map['createTime'].toString()
            : '';
        model.messageDesc = !ISEmpty(_map['messageDesc'])
            ? _map['messageDesc'].toString()
            : '--';
        model.messageTitle = !ISEmpty(_map['messageTitle'])
            ? _map['messageTitle'].toString()
            : '--';
        _list.add(model);
      });
      return ApiResponse(success: response.success, data: _list);
    } else {
      return ApiResponse(success: false);
    }
  }
}
