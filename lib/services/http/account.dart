import 'package:code/models/http/user_model.dart';
import 'package:code/utils/http_util.dart';
class Account {
  static Future<ApiResponse<User>> thirdLogin(Map<String,dynamic> data) async {
    final _data = data;
    final response = await HttpUtil.post('/api/login/third', _data,showLoading: true);
    return ApiResponse(success: response.success,data: User.fromJson(response.data['data']));
  }
}
