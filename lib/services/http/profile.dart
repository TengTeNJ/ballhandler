import 'package:code/constants/constants.dart';
import 'package:code/utils/http_util.dart';

// 积分明细
class IntegralModel {
  String createTime = '----'; // 时间
  String integralName = '----'; // 积分名称
  int integralType = 1; // 积分进出账（1入账，2消费）
  int integralVal = 1; // 积分数量
  int modeId = 1; // 模式编号
  int sceneId = 1; // 场景编号
  String sourceType = 'Daly Train'; // 积分来源类型
  String get modelName {
    String modelId = (this.modeId).toString();
    String sceneId = this.sceneId.toString();
    String? name = kGameSceneAndModelMap[sceneId]?[modelId];
    return name ?? '';
  } // 模式显示名称
}

class IntegralDataModel {
  List<IntegralModel> data = [];
  int count = 0;
}

// 可兑换商品
class ExchangeGoodModel {
  double exchangeMoney = 0; // 兑换的金额
  int goodsId = 1; // 商品编号
  String goodsImage = ''; // 商品的图片
  int goodsIntegral = 1; // 所需要的积分
  String goodsName = ''; // 商品名称
}

class MyAccountDataModel {
  String avatar = ''; // 头像
  dynamic  avgPace = 0; // 最快速度
  String birthday = ''; // 生日
  String country = ''; // 国家
  int integral = 0; // 积分
  int memberId = 1; // 会员号
  int memberLevel = 1; // 会员等级
  String nickName = ''; // 昵称
  dynamic trainCount = 0; // 训练次数
  dynamic trainScore = 0; // 训练总得分
  dynamic trainTime = 0; // 训练总时常
  int upperLimit = 2000; // 等级积分上限
}
class VideoModel{
  String avgPace = '0.0';
  String createTime = '--';
  String modeId = '1';
  String sceneId = '1';
  String trainId = '1';
  String trainScore = '0';
  String trainTime = '45';
  String trainVideo = '';
  String? activityId;
  String? activityName;
  String? activityRemark;
}

class VideoDataModel {
  List<VideoModel> data = [];
  int count = 0;
}

class Profile {
  /*获取积分明细列表*/
  static Future<ApiResponse<IntegralDataModel>> queryIntegralListData(
      int page) async {
    final _data = {
      "limit": (kPageLimit * 2).toString(),
      "page": page.toString(),
    };
    final response = await HttpUtil.get('/api/member/integral/list', _data,
        showLoading: true);
    List<IntegralModel> _list = [];
    IntegralDataModel _model = IntegralDataModel();
    final _count = response.data['count'];
    _model.count = _count;
    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List;
      _array.forEach((element) {
        IntegralModel model = IntegralModel();
        final _map = element;
        model.integralName = !ISEmpty(_map['integralName'])
            ? _map['integralName'].toString()
            : '--';
        model.sourceType =
        !ISEmpty(_map['sourceType']) ? _map['sourceType'].toString() : '--';
        model.integralType =
        !ISEmpty(_map['integralType']) ? _map['integralType'] : 1;
        model.sceneId = !ISEmpty(_map['sceneId']) ? _map['sceneId'] : 1;
        model.modeId = !ISEmpty(_map['modeId']) ? _map['modeId'] : 1;
        model.integralVal =
        !ISEmpty(_map['integralVal']) ? _map['integralVal'] : 0;
        model.createTime =
        !ISEmpty(_map['createTime']) ? _map['createTime'].toString() : '--';
        _list.add(model);
      });
      _model.data = _list;
      return ApiResponse(success: response.success, data: _model);
    } else {
      return ApiResponse(success: false);
    }
  }

/*查询可兑换的商品列表*/
  static Future<ApiResponse<List<ExchangeGoodModel>>>
  queryIExchangeGoodsListData(int page) async {
    final _data = {
      "limit": kPageLimit.toString(),
      "page": page.toString(),
    };
    final response = await HttpUtil.get('/api/member/exchange/list', _data,
        showLoading: true);
    List<ExchangeGoodModel> _list = [];

    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List;
      _array.forEach((element) {
        ExchangeGoodModel model = ExchangeGoodModel();
        final _map = element;
        model.goodsImage =
        !ISEmpty(_map['goodsImage']) ? _map['goodsImage'].toString() : '';
        model.goodsName =
        !ISEmpty(_map['goodsName']) ? _map['goodsName'].toString() : '--';
        model.goodsId = !ISEmpty(_map['goodsId']) ? _map['goodsId'] : 1;
        model.goodsIntegral =
        !ISEmpty(_map['goodsIntegral']) ? _map['goodsIntegral'] : 1;
        model.exchangeMoney =
        !ISEmpty(_map['exchangeMoney']) ? _map['exchangeMoney'] : 0.1;
        _list.add(model);
      });
      return ApiResponse(success: response.success, data: _list);
    } else {
      return ApiResponse(success: false);
    }
  }

/*积分兑换*/
  static Future<ApiResponse<String>> exchange(int goodsId) async {
    // 组装数据
    final _data = {'goodsId': goodsId};
    final response = await HttpUtil.post('/api/member/exchange/save', _data,
        showLoading: true);
    return ApiResponse(success: response.success);
  }

/*获取我的账号信息*/
  static Future<ApiResponse<MyAccountDataModel>>
  queryIMyAccountInfoData() async {
    final response = await HttpUtil.get(
        '/api/member/index', null, showLoading: false);
    MyAccountDataModel model = MyAccountDataModel();
    if (response.success && response.data['data'] != null) {
      final element = response.data['data'];
      final _map = element;
      model.avatar =
      !ISEmpty(_map['avatar']) ? _map['avatar'].toString() : '';
      model.birthday =
      !ISEmpty(_map['birthday']) ? _map['birthday'].toString() : '--';
      model.country =
      !ISEmpty(_map['country']) ? _map['country'].toString() : '--';
      model.avgPace = !ISEmpty(_map['avgPace']) ? _map['avgPace'] : 0;
      model.integral = !ISEmpty(_map['integral']) ? _map['integral'] : 0;
      model.memberId = !ISEmpty(_map['memberId']) ? _map['memberId'] : 1;
      model.memberLevel =
      !ISEmpty(_map['memberLevel']) ? _map['memberLevel'] : 1;
      model.nickName =
      !ISEmpty(_map['nickName']) ? _map['nickName'].toString() : '--';
      model.trainCount =
      !ISEmpty(_map['trainCount']) ? _map['trainCount'] : 0;
      model.trainScore =
      !ISEmpty(_map['trainScore']) ? _map['trainScore'] : 0;
      model.trainTime =
      !ISEmpty(_map['trainTime']) ? _map['trainTime'] : 0;
      model.upperLimit =
      !ISEmpty(_map['upperLimit']) ? _map['upperLimit'] : 1000;
      return ApiResponse(success: response.success, data: model);
    } else {
      return ApiResponse(success: false);
    }
  }

  /*查询用户下的视频列表*/
  static Future<ApiResponse> queryUserVideoListData(int page) async {
    final _data = {
      "limit": (kPageLimit * 2).toString(),
      "page": page.toString(),
    };
    final response = await HttpUtil.get('/api/train/video/list', _data,
        showLoading: true);
    List<VideoModel> _list = [];
    VideoDataModel _model = VideoDataModel();
    final _count = response.data['count'];
    _model.count = _count;
    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List;
      _array.forEach((element) {
        VideoModel model = VideoModel();
        final _map = element;
        model.avgPace = !ISEmpty(_map['avgPace'])
            ? _map['avgPace'].toString()
            : '--';
        model.createTime =
        !ISEmpty(_map['createTime']) ? _map['createTime'].toString() : '--';
        model.modeId =
        !ISEmpty(_map['modeId']) ? _map['modeId'].toString() : '1';
        model.sceneId = !ISEmpty(_map['sceneId']) ? _map['sceneId'].toString() : '1';
        model.trainId =
        !ISEmpty(_map['trainId']) ? _map['trainId'].toString() : '1';
        model.trainScore =
        !ISEmpty(_map['trainScore']) ? _map['trainScore'].toString() : '--';
        model.trainTime =
        !ISEmpty(_map['trainTime']) ? _map['trainTime'].toString() : '45';
        model.trainVideo =
        !ISEmpty(_map['trainVideo']) ? _map['trainVideo'].toString() : '';
        model.activityId =
        !ISEmpty(_map['activityId']) ? _map['activityId'].toString() : '';
        model.activityName =
        !ISEmpty(_map['activityName']) ? _map['activityName'].toString() : '';
        model.activityRemark =
        !ISEmpty(_map['activityRemark']) ? _map['activityRemark'].toString() : '';
        _list.add(model);
      });
      _model.data = _list;
      return ApiResponse(success: response.success, data: _model);
    } else {
      return ApiResponse(success: false);
    }
  }

/*查询用户下的视频个数*/
  static Future<ApiResponse<int>> queryUserVideoCountData() async {
    final _data = {
      "limit": '1',
      "page": '1',
    };
    final response = await HttpUtil.get('/api/train/video/list', _data,
        showLoading: true);
    VideoDataModel _model = VideoDataModel();
    if (response.success && response.data['data'] != null) {
      final _count = response.data['count'];
      _model.count = _count;
      return ApiResponse(success: response.success, data: _count);
    } else {
      return ApiResponse(success: false);
    }
  }

  static Future<ApiResponse<int>> deleteVideo(String trainId) async {
    final _data = {
      "trainId": trainId,
    };
    final response = await HttpUtil.post('/api/train/video/delete', _data,
        showLoading: true);
      return ApiResponse(success: response.success);
  }

}
