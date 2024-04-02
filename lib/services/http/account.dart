import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/models/http/user_model.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:flutter/material.dart';
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
    final response = await HttpUtil.get('/api/login/loginByPwd', _data,showLoading: true);
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
/*校验账号是否已存在*/
  static Future<ApiResponse<bool>> checkeEmail(String account) async{
    final email = await NSUserDefault.getValue<String>(kInputEmail);
    Map<String,dynamic> _data = {
      "account":email,
    };
    final response = await HttpUtil.get('/api/login/checkEmail', _data);
    return ApiResponse(success: response.success,data: response.data['code'] == '0');
  }

  /*处理登录成功后返回的数据*/
 static handleUserData(ApiResponse<User> _response, BuildContext context) {
    NSUserDefault.setKeyValue<String>(kUserName, _response.data!.nickName);
    NSUserDefault.setKeyValue<String>(kAccessToken, _response.data!.memberToken);
    NSUserDefault.setKeyValue<String>(kAvatar, _response.data!.avatar);
    UserProvider.of(context).userName = _response.data!.nickName;
    UserProvider.of(context).token = _response.data!.memberToken;
    UserProvider.of(context).avatar = _response.data!.avatar;
    UserProvider.of(context).createTime = _response.data!.createTime;

  }
}
