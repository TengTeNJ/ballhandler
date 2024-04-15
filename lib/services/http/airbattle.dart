import 'package:code/utils/http_util.dart';
import '../../constants/constants.dart';

class MyActivityModel{
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
class AirBattle{
  static Future<ApiResponse<List<MyActivityModel>>> queryMyActivityData(int page) async {
    final _data = {
      "limit":kPageLimit.toString(),
      "page":page.toString(),
    };
    final response = await HttpUtil.get('/api/activity/myList', _data,
        showLoading: true);
    List<MyActivityModel> _list = [];

    if (response.success && response.data['data'] != null) {
      final _array = response.data['data'] as List ;
      _array.forEach((element) {
        MyActivityModel model = MyActivityModel();
        final _map = element;
        model.avgPace =   !ISEmpty(_map['avgPace']) ?  _map['avgPace'].toString() :'--';
        model.rankNumber = !ISEmpty(_map['rankNumber']) ?  _map['rankNumber'].toString() :'--';
        model.activityIcon =   !ISEmpty(_map['activityIcon']) ?  _map['activityIcon'].toString() :'--';
        model.activityId =   !ISEmpty(_map['activityId']) ?  _map['activityId'].toString() :'--';
        model.activityName =   !ISEmpty(_map['activityName']) ?  _map['activityName'].toString() :'--';
        model.endDate =   !ISEmpty(_map['endDate']) ?  _map['endDate'].toString() :'--';
        model.startDate =   !ISEmpty(_map['startDate']) ?  _map['startDate'].toString() :'--';
        model.trainScore =   !ISEmpty(_map['trainScore']) ?  _map['trainScore'].toString() :'--';
        model.trainVideo =   !ISEmpty(_map['trainVideo']) ?  _map['trainVideo'].toString() :'--';
        _list.add(model);
      });
      return ApiResponse(
          success: response.success, data:_list);
    } else {
      return ApiResponse(success: false);
    }
  }
}

