import 'package:code/models/airbattle/award_model.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';
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
  int unreadCount = 0; // 未读消息的数量
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
  String rewardMoney = ''; // 活动奖励
  String rewardPoint = ''; // 活动积分
  String activityRule = ''; // 活动规则
  String get timeDifferentString {
    String targetTime = this.endDate + ' 23:59';
    DateTime time = StringUtil.showTimeStringToDate(targetTime);
    Duration remainingTime = time.difference(DateTime.now());
    int days = remainingTime.inDays;
    int hours = remainingTime.inHours % 24;
    int minutes = remainingTime.inMinutes % 60;
    return '${days} days ${hours} hours ${minutes} minutess';
  }

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

class ActivityDataModel {
  List<ActivityModel> data = [];
  int count = 0;
}

class MessageModel {
  String createTime = ''; // 发送时间
  String messageDesc = ''; // 消息描述
  String messageTitle = '';
  int isRead = 0; //  是否已读(0未读，1已读)
  int pushId = 0; // 消息推送编号
}

class  MessageDataModel{
  List<MessageModel> datas = [];
  int count = 0;
}

class AwardDataModel {
  List<AwardModel> data = [];
  int count = 0;
}

class ActivityDetailModel {
  String activityBackground = '';
  String activityIcon = '';
  int activityId = 1;
  String activityName = '';
  String sceneId = '1';
  String modeId = '1';
  String activityRemark = '';
  String activityRule = '';
  dynamic activityTime = 45;
  dynamic rewardMoney = 0;
  dynamic rewardPoint = 1;
  int activityStatus = 0; // 活动状态：0未开始 1正在进行 2已结束
  String endDate = ''; // 活动结束时间
  int isJoin = 0; // 是否加入过活动0未加入，1已加入
  ChampionModel champion = ChampionModel();
  SelfActivityModel self = SelfActivityModel();
  String get timeDifferentString {
    String targetTime = this.endDate + ' 23:59';
    DateTime time = StringUtil.showTimeStringToDate(targetTime);
    Duration remainingTime = time.difference(DateTime.now());
    int days = remainingTime.inDays;
    int hours = remainingTime.inHours % 24;
    int minutes = remainingTime.inMinutes % 60;
    print('${days}days${hours}hours${minutes}mins');
    return '${days} days ${hours} hours ${minutes} minutess';
  }
}

class ChampionModel {
  String championNickName = '';
  String championCountry = '';
  dynamic championTrainTime = 45;
  dynamic championAvgPace = '-';
  String championTrainScore = '0';
  dynamic championRankNumber = '1';
  String championTrainVideo = '';
  String createTime = '--';
}

class SelfActivityModel {
  String? country = '';
  String? nickName = '';
  dynamic? trainTime = 0;
  dynamic? avgPace = 0.0;
  String? trainScore = '0';
  dynamic? rankNumber = '-';
  String? trainVideo = '';
  String createTime = '--';
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
        model.endDate = !ISEmpty(_map['endDate'])
            ? StringUtil.serviceStringToShowDateString(
                _map['endDate'].toString())
            : '--';
        model.startDate = !ISEmpty(_map['startDate'])
            ? StringUtil.serviceStringToShowDateString(
                    _map['startDate'].toString())
                .toString()
            : '--';
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
  static Future<ApiResponse<ActivityDataModel>> queryAllActivityListData(
      int page) async {
    final _data = {
      "limit": kPageLimit.toString(),
      "page": page.toString(),
    };
    final response =
        await HttpUtil.get('/api/activity/allList', _data, showLoading: true);
    List<ActivityModel> _list = [];
    ActivityDataModel model = ActivityDataModel();
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
        model.endDate = !ISEmpty(_map['endDate'])
            ? StringUtil.serviceStringToShowDateString(
                _map['endDate'].toString())
            : '--';
        model.startDate = !ISEmpty(_map['startDate'])
            ? StringUtil.serviceStringToShowDateString(
                _map['startDate'].toString())
            : '--';
        model.activityName = !ISEmpty(_map['activityName'])
            ? _map['activityName'].toString()
            : '--';
        model.rewardMoney = !ISEmpty(_map['rewardMoney'])
            ? _map['rewardMoney'].toString()
            : '0';
        model.rewardPoint = !ISEmpty(_map['rewardPoint'])
            ? _map['rewardPoint'].toString()
            : '0';
        model.activityRemark = !ISEmpty(_map['activityRemark'])
            ? _map['activityRemark'].toString()
            : '--';
        model.activityRule = !ISEmpty(_map['activityRule'])
            ? _map['activityRule'].toString()
            : '--';
        _list.add(model);
      });
      model.data = _list;
      return ApiResponse(success: response.success, data: model);
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
      model.unreadCount =
          !ISEmpty(_map['unreadCount']) ? _map['unreadCount'] : 0;
      return ApiResponse(success: response.success, data: model);
    } else {
      return ApiResponse(success: false);
    }
  }

  /*查询未读消息的数量*/
  static Future<ApiResponse<int>> queryIUnreadCount() async {
    final response =
    await HttpUtil.get('/api/activity/index', null, showLoading: false);
    if (response.success && response.data['data'] != null) {
      final element = response.data['data'];
      int unreadCount =
      !ISEmpty(element['unreadCount']) ? element['unreadCount'] : 0;
      return ApiResponse(success: response.success, data: unreadCount);
    } else {
      return ApiResponse(success: false);
    }
  }

  /*查询所有的消息列表*/
  static Future<ApiResponse<MessageDataModel>> queryAllMessageListData(
      int page) async {
    final _data = {
      "limit": kPageLimit.toString(),
      "page": page.toString(),
    };
    final response =
        await HttpUtil.get('/api/message/list', _data, showLoading: true);
    MessageDataModel _model = MessageDataModel();

    List<MessageModel> _list = [];
    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List;
      _array.forEach((element) {
        MessageModel model = MessageModel();
        final _map = element;
        model.createTime =
            !ISEmpty(_map['createTime']) ? _map['createTime'].toString() : '';
        model.messageDesc = !ISEmpty(_map['messageDesc'])
            ? _map['messageDesc'].toString()
            : '--';
        model.messageTitle = !ISEmpty(_map['messageTitle'])
            ? _map['messageTitle'].toString()
            : '--';
        model.pushId = !ISEmpty(_map['pushId'])
            ? _map['pushId']
            : 0;
        model.isRead = !ISEmpty(_map['isRead'])
            ? _map['isRead']
            : 0;
        _list.add(model);
      });
      _model.count = ISEmpty( response.data['count']) ? 0 : response.data['count'];
      _model.datas = _list;
      return ApiResponse(success: response.success, data: _model);
    } else {
      return ApiResponse(success: false);
    }
  }

  /*查询我的奖励的数据*/
  static Future<ApiResponse<AwardDataModel>> queryMyAwardData(int page) async {
    final _data = {
      "limit": kPageLimit.toString(),
      "page": page.toString(),
    };
    final response =
        await HttpUtil.get('/api/member/reward/list', _data, showLoading: true);
    AwardDataModel awardDataModelodel = AwardDataModel();
    List<AwardModel> _list = [];

    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List;
      _array.forEach((element) {
        AwardModel model = AwardModel();
        final _map = element;
        model.activityName = !ISEmpty(_map['activityName'])
            ? _map['activityName'].toString()
            : '--';

        model.rewardMoney =
            !ISEmpty(_map['rewardMoney']) ? _map['rewardMoney'] : 0.0;

        model.rewardStatus =
            !ISEmpty(_map['rewardStatus']) ? _map['rewardStatus'] : 0;
        model.createTime =
            !ISEmpty(_map['createTime']) ? _map['createTime'].toString() : '--';
        model.rewardId =
        !ISEmpty(_map['rewardId']) ? _map['rewardId'].toString() : '1';

        _list.add(model);
      });
      awardDataModelodel.data = _list;
      return ApiResponse(success: response.success, data: awardDataModelodel);
    } else {
      return ApiResponse(success: false);
    }
  }

/*查询活动详情*/
  static Future<ApiResponse<ActivityDetailModel>> queryIActivityDetailData(
      int activityId) async {
    final response = await HttpUtil.get(
        '/api/activity/detail', {"activityId": activityId.toString()},
        showLoading: true);
    ActivityDetailModel model = ActivityDetailModel();
    SelfActivityModel self = SelfActivityModel();
    ChampionModel championModel = ChampionModel();
    if (response.success && response.data['data'] != null) {
      final element = response.data['data'];
      final _map = element;
      model.activityStatus =
          !ISEmpty(_map['activityStatus']) ? _map['activityStatus'] : 0;
      model.activityBackground = !ISEmpty(_map['activityBackground'])
          ? _map['activityBackground'].toString()
          : '';
      model.activityIcon =
          !ISEmpty(_map['activityIcon']) ? _map['activityIcon'].toString() : '';
      model.activityName =
          !ISEmpty(_map['activityName']) ? _map['activityName'].toString() : '';
      model.activityRemark = !ISEmpty(_map['activityRemark'])
          ? _map['activityRemark'].toString()
          : '';
      model.activityRule =
          !ISEmpty(_map['activityRule']) ? _map['activityRule'].toString() : '';
      model.activityTime =
          !ISEmpty(_map['activityTime']) ? _map['activityTime'] : 45;
      model.rewardMoney =
          !ISEmpty(_map['rewardMoney']) ? _map['rewardMoney'] : 0;
      model.rewardPoint =
          !ISEmpty(_map['rewardPoint']) ? _map['rewardPoint'] : 0;
      model.endDate = !ISEmpty(_map['endDate'])
          ? StringUtil.serviceStringToShowDateString(_map['endDate'].toString())
          : '';
      model.isJoin =
      !ISEmpty(_map['isJoin']) ? _map['isJoin'] : 0;
      model.sceneId = !ISEmpty(_map['sceneId'])
          ? _map['sceneId'].toString()
          : '1';
      model.modeId = !ISEmpty(_map['modeId'])
          ? _map['modeId'].toString()
          : '1';
      if (model.activityStatus != 0) {
        /*用户的活动数据*/
        self.nickName = await NSUserDefault.getValue(kUserName);
        self.country =
        await NSUserDefault.getValue(kCountry);
        self.avgPace = !ISEmpty(_map['avgPace']) ? _map['avgPace'] .toString(): '-';
        self.avgPace = !ISEmpty(_map['avgPace']) ? _map['avgPace'] .toString(): '-';
        self.trainScore =
            !ISEmpty(_map['trainScore']) ? _map['trainScore'].toString() : '-';
        self.rankNumber =  !ISEmpty(_map['rankNumber']) ? _map['rankNumber'].toString() : '-';
        self.trainVideo =
            !ISEmpty(_map['trainVideo']) ? _map['trainVideo'].toString() : '';
        self.createTime =
        !ISEmpty(_map['createTime']) ? StringUtil.serviceStringToShowDateString(_map['createTime'].toString()) : '--';
        model.self = self;
      }
      if (model.activityStatus == 2) {
        /*冠军数据*/
        championModel.championCountry = !ISEmpty(_map['championCountry'])
            ? _map['championCountry'].toString()
            : '';
        championModel.championNickName = !ISEmpty(_map['championNickName'])
            ? _map['championNickName'].toString()
            : '';
        championModel.championTrainTime =
            !ISEmpty(_map['championTrainTime']) ? _map['championTrainTime'] : 0;
        championModel.championAvgPace =
            !ISEmpty(_map['championAvgPace']) ? _map['championAvgPace'].toString() : '0';
        championModel.championTrainScore = !ISEmpty(_map['championTrainScore'])
            ? _map['championTrainScore'].toString()
            : '-';
        championModel.championCountry = !ISEmpty(_map['championCountry'])
            ? _map['championCountry'].toString()
            : '';
        championModel.championRankNumber = !ISEmpty(_map['championRankNumber'])
            ? _map['championRankNumber'].toString()
            : '1';
        championModel.championTrainVideo = !ISEmpty(_map['championTrainVideo'])
            ? _map['championTrainVideo'].toString()
            : '';
        championModel.createTime =
        !ISEmpty(_map['championCreateTime']) ? StringUtil.serviceStringToShowDateString(_map['championCreateTime'].toString()) : '--';
        model.champion = championModel;
      }
      return ApiResponse(success: response.success, data: model);
    } else {
      return ApiResponse(success: false);
    }
  }

/*消息阅读接口*/
  static Future<ApiResponse> readMessage(int pushId) async {
    final response = await HttpUtil.get(
        '/api/message/detail', {"pushId": pushId.toString()},
        showLoading: true);
    return ApiResponse(success: response.success);
  }
  /*阅读奖励消息*/
  static Future<ApiResponse> readAwardMessage(String rewardId) async {
    final response = await HttpUtil.get(
        '/api/member/reward/detail', {"rewardId": rewardId},
        showLoading: true);
    return ApiResponse(success: response.success);
  }


  /*报名参加活动接口*/
  static Future<ApiResponse> joinActivity(int activityId) async {
    final response = await HttpUtil.post(
        '/api/activity/join', {"activityId": activityId},
        showLoading: true);
    return ApiResponse(success: response.success);
  }
}
