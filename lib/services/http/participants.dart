import 'package:camera/camera.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/utils/global.dart';
import 'package:code/utils/http_util.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

class HomeUsermodel {
  String avgPace;
  String rankNumber;
  String trainCount;
  String trainScore;
  String trainTime;

  HomeUsermodel(
      {this.avgPace = '--',
      this.trainCount = '0',
      this.trainScore = '0',
      this.trainTime = '0',
      this.rankNumber = '--'});
}

class Participants {
  /*获取首页用户的数据*/
  static Future<ApiResponse<HomeUsermodel>> getHomeUserData(
      String sceneId) async {
    final _data = {
      "sceneId": sceneId,
    };
    final response =
        await HttpUtil.get('/api/index/home', _data, showLoading: false);
    HomeUsermodel model = HomeUsermodel();
    if (response.success && response.data['data'] != null) {
      model = HomeUsermodel(
          avgPace: response.data['data']['avgPace'].toString(),
          trainCount: response.data['data']['trainCount'].toString(),
          trainScore: response.data['data']['trainScore'].toString(),
          trainTime: response.data['data']['trainTime'].toString());
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
  static Future<ApiResponse<String>> saveGameData(GameOverModel data) async {
    // 获取场景ID
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    print('score=${data.score}');
    // 组装数据
    final _data = {
      "activityId": gameUtil.isFromAirBattle ?gameUtil.activityModel.activityId : '0',
      "modeId": 0,
      "avgPace": data.avgPace,
      "sceneId": (gameUtil.gameScene.index + 1).toString(),
      "trainScore": data.score,
      "trainTime": data.time,
      "trainVideo": data.videoPath,
      "trainIntegral": data.Integral,
      "trainType": gameUtil.isFromAirBattle?1:0,
    };
    final response =
        await HttpUtil.post('/api/train/save', _data, showLoading: true);
    return ApiResponse(success: response.success);
  }

  /*根据本人最好成绩的排名和速度*/
  static Future<ApiResponse<HomeUsermodel>> queryRankData() async {
    // 获取场景ID
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    final _data = {
      "sceneId": (gameUtil.gameScene.index + 1).toString(),
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


  static Future<ApiResponse<String>> uploadAsset(String path) async {

    XFile file = XFile(path);
    var postData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
          file.path, filename: file.name)
    });
    print('postData---${postData}');
    print('name---${file.name}');
    print('path---${file.path}');

    final response = await HttpUtil.post('/api/oss/upload', postData,
        showLoading: true);
    if (response.success && response.data['data'] != null) {
      String url = response.data['data'][0] ?? '';
      return ApiResponse(
          success: response.success,data: url);
    } else {
      return ApiResponse(success: false);
    }
  }

}
