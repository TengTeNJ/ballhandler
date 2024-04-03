import 'package:flutter/material.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';

class HomeUsermodel {
  String avgPace;

  String trainCount;
  String trainScore;
  String trainTime;

  HomeUsermodel(
      {required this.avgPace,
      required this.trainCount,
      required this.trainScore,
      required this.trainTime});
}

class Participants {
  /*获取首页用户的数据*/
  static Future<ApiResponse<HomeUsermodel>> getHomeUserData(
      String sceneId) async {
    final _data = {
      "sceneId": sceneId,
    };
    final response =
        await HttpUtil.get('/api/index/home', _data, showLoading: true);
    HomeUsermodel model;
    if (response.success && response.data['data']) {
      model = HomeUsermodel(
          avgPace: response.data['data']['avgPace'],
          trainCount: response.data['data']['avgPace'],
          trainScore: response.data['data']['trainScore'],
          trainTime: response.data['data']['trainTime']);
      return ApiResponse(success: response.success, data: model);
    } else {
      return ApiResponse(success: false);
    }
  }
}
