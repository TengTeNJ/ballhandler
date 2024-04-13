import 'package:code/utils/http_util.dart';
import 'package:get_it/get_it.dart';
import '../../constants/constants.dart';
import '../../utils/global.dart';

class RankModel{
  String ?rankNumber;
  String ?avgPace;
  String ?nickName;
  String ?avatar;
  String ?country;
  String trainVideo = '';
}
class Rank{
  static Future<ApiResponse<List<RankModel>>> queryRankListData(int page) async {
    // 获取场景ID
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    final _data = {
      "limit":kPageLimit.toString(),
      "page":page.toString(),
      "sceneId": (gameUtil.gameScene.index + 1).toString(),
    };
    final response = await HttpUtil.get('/api/statistic/rankList', _data,
        showLoading: false);
   List<RankModel> _list = [];

    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List ;
      _array.forEach((element) {
        RankModel model = RankModel();
        final _map = element;
        model.avgPace =   !ISEmpty(_map['avgPace']) ?  _map['avgPace'].toString() :'--';
        model.rankNumber = !ISEmpty(_map['rankNumber']) ?  _map['rankNumber'].toString() :'--';
        model.nickName = !ISEmpty(_map['nickName']) ?  _map['nickName'].toString() :'--';
        model.avatar = !ISEmpty(_map['avatar']) ?  _map['avatar'].toString() :'';
        model.country = !ISEmpty(_map['country']) ?  _map['country'].toString() :'China';
        model.trainVideo = !ISEmpty(_map['trainVideo']) ?  _map['trainVideo'].toString() :'';
        _list.add(model);
      });
      return ApiResponse(
          success: response.success, data:_list);
    } else {
      return ApiResponse(success: false);
    }
  }
}