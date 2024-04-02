import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/models/http/user_model.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';
class Account {
  /*第三方登录*/
  static Future<ApiResponse<User>> thirdLogin(Map<String,dynamic> data) async {
    final _data = data;
    final response = await HttpUtil.post('/api/login/third', _data,showLoading: true);
    return ApiResponse(success: response.success,data:  User.fromJson(response.data['data']??{}));
  }
  /*邮箱注册接口*/
  static Future<ApiResponse<User>> emailRegister(String code,String pwd) async {
    final email = NSUserDefault.getValue<String>(kInputEmail);
    final _data = {
      "account": email ?? '',
      "code": code,
      "password": pwd
    };
    final response = await HttpUtil.post('/api/login/register', _data,showLoading: true);
    return ApiResponse(success: response.success,data: User.fromJson(response.data['data']));
  }
  /*发送验证码*/
  static Future<ApiResponse> sendEmail() async {
    final email = await NSUserDefault.getValue<String>(kInputEmail);
    final _data = {
      "email": email ,
    };
    final response = await HttpUtil.get('/api/login/sendEmailVerifyCode', _data ,showLoading: true);
    return ApiResponse(success: response.success);
  }
  /*使用邮箱登录*/
  static Future<ApiResponse<User>> emailLogin(String password) async{
    final email = await NSUserDefault.getValue<String>(kInputEmail);
    Map<String,dynamic> _data = {
      "account":email,
      "password":password
    };
    final response = await HttpUtil.get('/api/login/loginByPwd', _data);
    return ApiResponse(success: response.success,data: User.fromJson(response.data['data']??{}));
  }
/*
* 使用邮箱注册账号*/
  static Future<ApiResponse> registerWithEmail(String password,String birthday,String nickName) async{
    final email = await NSUserDefault.getValue<String>(kInputEmail);
    final _data = {
      "account":email,
      "password":password,
      "birthday": birthday,
      "nickName": nickName
    };
    final response = await HttpUtil.post('/api/login/register', _data,showLoading: true);
    return ApiResponse(success: response.success);
  }


}
