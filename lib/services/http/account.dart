import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/models/http/user_model.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/global.dart';
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
    if(response.success){
      NSUserDefault.setKeyValue(kUserEmail, email);
    }
    return ApiResponse(success: response.success,data: response.success ? User.fromJson(response.data['data']) : null);
  }
/*
* 使用邮箱注册账号*/
  static Future<ApiResponse> registerWithEmail(String password,String birthday,String nickName,String country) async{
    final email = await NSUserDefault.getValue<String>(kInputEmail);
    final _data = {
      "account":email,
      "password":password,
      "birthday": birthday,
      "nickName": nickName,
      "country":country,
    };
    final response = await HttpUtil.post('/api/login/register', _data,showLoading: true);
    return ApiResponse(success: response.success);
  }
/*校验账号是否已存在*/
  static Future<ApiResponse<bool>> checkeEmail(String account) async{
    Map<String,dynamic> _data = {
      "account":account,
    };
    final response = await HttpUtil.get('/api/login/checkEmail', _data);
    return ApiResponse(success: response.success,data: response.data['code'] == '0');
  }
  /*检测是否设置过用户信息*/
  static Future<ApiResponse<bool>> checkeSetUserInfoStatu() async{
    final response = await HttpUtil.get('/api/member/ifSetMainParams',null);
    return ApiResponse(success: response.success,data: response.data['data'] == true);
  }

/*修改用户信息*/
  static Future<ApiResponse> updateUserInfo(Map<String,dynamic> data) async{
    final response = await HttpUtil.post('/api/member/update',data);
    return ApiResponse(success: response.success);
  }

  /*更新用户信息，包括头像、国家、生日、推送的token等消息 birthday firebaseToken nickName*/
  static Future<ApiResponse> updateAccountInfo(Map<String,dynamic> data) async {
    final _data = data;
    final response = await HttpUtil.post('/api/member/update',  _data,showLoading: true,);
    return ApiResponse(success: response.success,);
  }

  static Future<ApiResponse> sendFogetPwdEmail(String email) async{
    Map<String,dynamic> _data = {
      "email":email,
    };
    final response = await HttpUtil.get('/api/login/sendEmailForget', _data);
    return ApiResponse(success: response.success,);
  }

  /*处理登录成功后返回的数据*/
 static handleUserData(ApiResponse<User> _response, BuildContext context) async{
    NSUserDefault.setKeyValue<String>(kUserName, _response.data!.nickName);
    NSUserDefault.setKeyValue<String>(kAccessToken, _response.data!.memberToken);
    NSUserDefault.setKeyValue<String>(kAvatar, _response.data!.avatar);
    NSUserDefault.setKeyValue<String>(kBrithDay, _response.data!.birthday);
    NSUserDefault.setKeyValue<String>(kCountry, _response.data!.country);

    UserProvider.of(context).userName = ISEmpty(_response.data!.nickName) ? '--' : _response.data!.nickName;
    UserProvider.of(context).token = _response.data!.memberToken;
    UserProvider.of(context).avatar = _response.data!.avatar;
    UserProvider.of(context).createTime = _response.data!.createTime;
    UserProvider.of(context).country = ISEmpty(_response.data!.country) ? '--' : _response.data!.country;
    UserProvider.of(context).brith = ISEmpty(_response.data!.birthday) ? '--' : _response.data!.birthday;

    final _email = await NSUserDefault.getValue(kUserEmail);
    UserProvider.of(context).email = _email ?? '';

    // 登录成功后绑定用户和推送的token
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    updateAccountInfo({
      "firebaseToken" : gameUtil.firebaseToken
    });

    String userName =  await NSUserDefault.getValue(kUserName) ?? '--';
    String email =  await NSUserDefault.getValue(kUserEmail) ?? '--';
    if(userName!=null && userName.length > 0){
      FirebaseCrashlytics.instance.log("userName:${userName}-email:${email}");
      FirebaseCrashlytics.instance.setCustomKey('userName', userName);
      FirebaseCrashlytics.instance.setCustomKey('email', email ?? '--');
    }
  }
}
