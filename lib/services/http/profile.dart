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
    String modelId = (this.modeId + 1).toString();
    String sceneId = this.sceneId.toString();
    String? name = kGameSceneAndModelMap[sceneId]?[modelId];
    return name ?? '';
  } // 模式显示名称
}

// 可兑换商品
class ExchangeGoodModel {
  double exchangeMoney = 0; // 兑换的金额
  int goodsId = 1; // 商品编号
  String goodsImage = ''; // 商品的图片
  int goodsIntegral = 1; // 所需要的积分
  String goodsName = ''; // 商品名称
}

class Profile {
  /*获取积分明细列表*/
  static Future<ApiResponse<List<IntegralModel>>> queryIntegralListData(
      int page) async {
    final _data = {
      "limit": kPageLimit.toString(),
      "page": page.toString(),
    };
    final response = await HttpUtil.get('/api/member/integral/list', _data,
        showLoading: true);
    List<IntegralModel> _list = [];

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
      return ApiResponse(success: response.success, data: _list);
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
    final response =
        await HttpUtil.post('/api/member/exchange/save', _data, showLoading: true);
    return ApiResponse(success: response.success);
  }
}
