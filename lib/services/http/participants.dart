import 'package:camera/camera.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/utils/global.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/string_util.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../../constants/constants.dart';

class HomeUsermodel {
  String avgPace;
  String rankNumber;
  String trainCount;
  String trainScore;
  String trainTime;
  int noticeType = 0; // 公告类型：0无；1获奖；2补充信息

  HomeUsermodel(
      {this.avgPace = '--',
      this.trainCount = '0',
      this.trainScore = '0',
      this.trainTime = '0',
      this.rankNumber = '--',
      this.noticeType = 0});
}

class GameModel {
  String modeId = '1'; // 模式id
  String modeName = ''; // 模式名称
  String modeRemark = ''; // 模式描述
  String trainTime = ''; // 游戏时间
  int difficultyLevel = 1; // 难易程度
}

class GameJoinCountModel{
  int totalMemberCount  = 0; // 活动+日常训练总人数
  int activityMemberCount = 0;// 活动参与总人数
  int trainMemberCount = 0; // 日常训练总人数
}

class SceneModel {
  String dictKey = '1';
  String dictValue = 'Digital Stickhandling Trainer';
  String dictRemark = 'Sharpen your stickhandling and reaction time with interactive challenges that also encourage you to glance up and maintain awareness. Watch yourself in action and perfect your technique in real-time.Select your challenge mode by shape, dive into quick tutorials, and push your limits.';
}

class Participants {
  /*获取首页用户的数据*/
  static Future<ApiResponse<HomeUsermodel>> getHomeUserData() async {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    final _data = {
      "sceneId": (gameUtil.gameScene.index + 1).toString(),
    };
    final response =
        await HttpUtil.get('/api/index/home', _data, showLoading: false);
    HomeUsermodel model = HomeUsermodel();
    if (response.success && response.data['data'] != null) {
      model = HomeUsermodel(
          avgPace: response.data['data']['avgPace'].toString(),
          trainCount: response.data['data']['trainCount'].toString(),
          trainScore: response.data['data']['trainScore'].toString(),
          trainTime: response.data['data']['trainTime'].toString(),
          noticeType: response.data['data']['noticeType'] ?? 0);
      return ApiResponse(success: response.success, data: model);
    } else {
      return ApiResponse(success: false);
    }
  }

/*根据得分获取当前得分的全网排名*/
  static Future<ApiResponse<String>> queryRankBaseScore(String avgPace) async {
    // 获取场景ID
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    final _data = {
      "avgPace": avgPace,
      "sceneId": (gameUtil.gameScene.index + 1).toString(),
    };
    final response =
        await HttpUtil.get('/api/train/rank', _data, showLoading: true);
    if (response.success && response.data['data'] != null) {
      return ApiResponse(
          success: response.success, data: response.data['data'].toString());
    } else {
      return ApiResponse(success: false);
    }
  }

/*保存游戏数据*/
  static Future<ApiResponse<String>> saveGameData(GameOverModel data,{double size = 0}) async {
    // 获取场景ID
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    print('score=${data.score}');
    // 组装数据
    final _data = {
      "activityId":
          gameUtil.isFromAirBattle ? gameUtil.activityModel.activityId : '0',
      "modeId": gameUtil.modelId,
      "avgPace": data.avgPace,
      "sceneId": (gameUtil.gameScene.index + 1).toString(),
      "trainScore": data.score,
      "trainTime": data.time,
      "trainVideo": data.videoPath ?? '',
      "trainIntegral": data.Integral,
      "trainType": gameUtil.isFromAirBattle ? 1 : 0,
      "videoSize": size.toString()
    };
    final response =
        await HttpUtil.post('/api/train/save', _data, showLoading: true);
    return ApiResponse(success: response.success);
  }

  /*根据本人最好成绩的排名和速度*/
  static Future<ApiResponse<HomeUsermodel>> queryRankData(int sceneId) async {
    // 获取场景ID
    final _data = {
      "sceneId": sceneId.toString(),
    };
    final response = await HttpUtil.get('/api/statistic/rankData', _data,
        showLoading: false);
    HomeUsermodel model = HomeUsermodel();
    if (response.success && response.data['data'] != null) {
      final _map = response.data['data'];
      model.avgPace = _map['avgPace'].toString();
      model.rankNumber = _map['rankNumber'].toString();
      model.trainCount = _map['trainCount'].toString();
      model.trainScore = _map['trainScore'].toString();
      model.trainTime = _map['trainTime'].toString();
      return ApiResponse(success: response.success, data: model);
    } else {
      return ApiResponse(success: false);
    }
  }

/*上传文件接口*/
  static Future<ApiResponse<String>> uploadAsset(String path) async {
    XFile file = XFile(path);
    var postData = FormData.fromMap(
        {"file": await MultipartFile.fromFile(file.path, filename: file.name)});
    print('postData---${postData}');
    print('name---${file.name}');
    print('path---${file.path}');

    final response =
        await HttpUtil.post('/api/oss/upload', postData, showLoading: true);
    if (response.success && response.data['data'] != null) {
      String url = response.data['data'][0] ?? '';
      return ApiResponse(success: response.success, data: url);
    } else {
      return ApiResponse(success: false);
    }
  }

  /*查询训练列表接口*/
  static Future<ApiResponse<List<GameOverModel>>> queryTrainListData(
      int page, String startDate, String endDate) async {
    // 获取场景ID
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    final _data = {
      "sceneId": (gameUtil.gameScene.index + 1).toString(),
      "limit": (kPageLimit * 3).toString(),
      "page": page.toString(),
      "startDate": startDate,
      "endDate": endDate
    };
    final response =
        await HttpUtil.get('/api/train/list', _data, showLoading: true);
    List<GameOverModel> _list = [];

    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List;
      _array.forEach((element) {
        GameOverModel model = GameOverModel();
        final _map = element;
        model.avgPace =
            !ISEmpty(_map['avgPace']) ? _map['avgPace'].toString() : '--';
        model.score =
            !ISEmpty(_map['trainScore']) ? _map['trainScore'].toString() : '--';
        model.endTime = !ISEmpty(_map['createTime'])
            ? StringUtil.serviceStringToShowMinuteString(
                _map['createTime'].toString())
            : '--';
        model.videoPath =
            !ISEmpty(_map['trainVideo']) ? _map['trainVideo'].toString() : '--';
        model.sceneId =
            !ISEmpty(_map['sceneId']) ? _map['sceneId'].toString() : '1';
        model.modeId =
            !ISEmpty(_map['modeId']) ? _map['modeId'].toString() : '1';
        _list.add(model);
      });
      return ApiResponse(success: response.success, data: _list);
    } else {
      return ApiResponse(success: false);
    }
  }

  /*查询训练模式列表接口*/
  static Future<ApiResponse<List<GameModel>>> queryModelListData() async {
    // 获取场景ID
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    final _data = {
      "sceneId": (gameUtil.gameScene.index + 1).toString(),
    };
    final response =
        await HttpUtil.get('/api/train/mode/list', _data, showLoading: true);
    List<GameModel> _list = [];

    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List;
      _array.forEach((element) {
        GameModel model = GameModel();
        final _map = element;
        model.modeId =
            !ISEmpty(_map['modeId']) ? _map['modeId'].toString() : '1';
        model.difficultyLevel =
            !ISEmpty(_map['difficultyLevel']) ? _map['difficultyLevel'] : 1;
        model.modeName = !ISEmpty(_map['modeName']) ? _map['modeName'] : '--';
        model.modeRemark =
            !ISEmpty(_map['modeRemark']) ? _map['modeRemark'].toString() : '--';

        model.trainTime =
            !ISEmpty(_map['trainTime']) ? _map['trainTime'].toString() : '45';
        _list.add(model);
      });
      return ApiResponse(success: response.success, data: _list);
    } else {
      return ApiResponse(success: false);
    }
  }

  /*根据本人最好成绩的排名和速度*/
  static Future<ApiResponse<GameJoinCountModel>> queryJoinCount(String modeId) async {
    // 获取场景ID
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    final _data = {
      "sceneId": (gameUtil.gameScene.index + 1).toString(),
      "modeId" : modeId
    };
    final response = await HttpUtil.get('/api/train/getTrainMemberCount', _data,
        showLoading: false);
    GameJoinCountModel model = GameJoinCountModel();
    if (response.success && response.data['data'] != null) {
      final _map = response.data['data'];
      model.totalMemberCount = _map['totalMemberCount'] ?? 0;
      model.activityMemberCount = _map['activityMemberCount'] ?? 0;
      model.trainMemberCount = _map['trainMemberCount'] ?? 0;
      return ApiResponse(success: response.success, data: model);
    } else {
      return ApiResponse(success: false);
    }
  }

  /*查询训练场景列表接口*/
  static Future<ApiResponse<List<SceneModel>>> querySceneListData() async {
    final response =
    await HttpUtil.get('/api/train/scene/list', null, showLoading: false);
    List<SceneModel> _list = [];
    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List;
      _array.forEach((element) {
        SceneModel model = SceneModel();
        final _map = element;
        model.dictKey =
        !ISEmpty(_map['dictKey']) ? _map['dictKey'].toString() : '1';
        model.dictValue =
        !ISEmpty(_map['dictValue']) ? _map['dictValue'] : '-';
        model.dictRemark =
        !ISEmpty(_map['dictRemark']) ? _map['dictRemark'] : '-';
        _list.add(model);
      });
      return ApiResponse(success: response.success, data: _list);
    } else {
      return ApiResponse(success: false);
    }
  }
}
