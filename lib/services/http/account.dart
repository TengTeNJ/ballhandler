import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/models/http/subscribe_model.dart';
import 'package:code/models/http/user_model.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/global.dart';

class CheckResultModel {
  int thirdLoginType = 0; // 账号路径(0邮箱登录、1apple、2google、3facebook、4shopify)
  bool setPwdFlag = false; // 是否设置过密码
}

class Account {
  /*第三方登录*/
  static Future<ApiResponse<User>> thirdLogin(Map<String, dynamic> data) async {
    final _data = data;
    final response =
        await HttpUtil.post('/api/login/third', _data, showLoading: true);
    return ApiResponse(
        success: response.success,
        data: User.fromJson(response.data['data'] ?? {}));
  }

  /*邮箱注册接口*/
  static Future<ApiResponse<User>> emailRegister(
      String code, String pwd) async {
    final email = await NSUserDefault.getValue<String>(kInputEmail);
    final _data = {"account": email ?? '', "code": code, "password": pwd};
    final response =
        await HttpUtil.post('/api/login/register', _data, showLoading: true);
    return ApiResponse(
        success: response.success, data: User.fromJson(response.data['data']));
  }
  /*设置密码*/
  static Future<ApiResponse> setPwd(String pwd) async {
    final email = await NSUserDefault.getValue<String>(kInputEmail);
    final _data = {"account": email ?? '',  "password": pwd};
    final response =
    await HttpUtil.post('/api/login/forgetPwd', _data, showLoading: true);
    return ApiResponse(
        success: response.success);
  }

  /*发送验证码*/
  static Future<ApiResponse> sendEmail() async {
    final email = await NSUserDefault.getValue<String>(kInputEmail);
    final _data = {
      "email": email,
    };
    final response = await HttpUtil.get('/api/login/sendEmailVerifyCode', _data,
        showLoading: true);
    return ApiResponse(success: response.success);
  }

  /*使用邮箱登录*/
  static Future<ApiResponse<User>> emailLogin(String password) async {
    final email = await NSUserDefault.getValue<String>(kInputEmail);
    Map<String, dynamic> _data = {"account": email, "password": password};
    final response =
        await HttpUtil.get('/api/login/loginByPwd', _data, showLoading: true);
    if (response.success) {
      NSUserDefault.setKeyValue(kUserEmail, email);
    }
    return ApiResponse(
        success: response.success,
        data: response.success ? User.fromJson(response.data['data']) : null);
  }

/*
* 使用邮箱注册账号*/
  static Future<ApiResponse> registerWithEmail(
      String password, String birthday, String nickName, String country) async {
    final email = await NSUserDefault.getValue<String>(kInputEmail);
    final _data = {
      "account": email,
      "password": password,
      "birthday": birthday,
      "nickName": nickName,
      "country": country,
    };
    final response =
        await HttpUtil.post('/api/login/register', _data, showLoading: true);
    return ApiResponse(success: response.success);
  }

/*校验账号是否已存在*/
  static Future<ApiResponse<CheckResultModel>> checkeEmail(
      String account) async {
    Map<String, dynamic> _data = {
      "account": account,
    };
    final response = await HttpUtil.get('/api/login/checkEmail', _data);
    CheckResultModel model = CheckResultModel();
    Map _map = response.data['data'];
    if (_map != null) {
      model.thirdLoginType = ISEmpty(_map['thirdLoginType'])
          ? 0
          : (_map['thirdLoginType']);
      model.setPwdFlag =
          ISEmpty(_map['setPwdFlag']) ? false : (_map['setPwdFlag']) != 0;
    }
    return ApiResponse(success: response.success, data: model);
  }

  /*检测是否设置过用户信息*/
  static Future<ApiResponse<bool>> checkeSetUserInfoStatu() async {
    final response = await HttpUtil.get('/api/member/ifSetMainParams', null);
    return ApiResponse(
        success: response.success, data: response.data['data'] == true);
  }

/*修改用户信息*/
  static Future<ApiResponse> updateUserInfo(Map<String, dynamic> data) async {
    final response = await HttpUtil.post('/api/member/update', data);
    return ApiResponse(success: response.success);
  }

  /*更新用户信息，包括头像、国家、生日、推送的token等消息 birthday firebaseToken nickName*/
  static Future<ApiResponse> updateAccountInfo(
      Map<String, dynamic> data) async {
    final _data = data;
    final response = await HttpUtil.post(
      '/api/member/update',
      _data,
      showLoading: true,
    );
    return ApiResponse(
      success: response.success,
    );
  }

  static Future<ApiResponse> sendFogetPwdEmail(String email) async {
    Map<String, dynamic> _data = {
      "email": email,
    };
    final response = await HttpUtil.get('/api/login/sendEmailForget', _data,
        showLoading: true);
    return ApiResponse(
      success: response.success,
    );
  }

  /*处理登录成功后返回的数据*/
  static handleUserData(
      ApiResponse<User> _response, BuildContext context) async {
    NSUserDefault.setKeyValue<String>(kUserName, _response.data!.nickName);
    NSUserDefault.setKeyValue<String>(
        kAccessToken, _response.data!.memberToken);
    NSUserDefault.setKeyValue<String>(kAvatar, _response.data!.avatar);
    NSUserDefault.setKeyValue<String>(kBrithDay, _response.data!.birthday);
    NSUserDefault.setKeyValue<String>(kCountry,
        ISEmpty(_response.data!.country) ? 'Unknown' : _response.data!.country);
    NSUserDefault.setKeyValue<String>(kUserEmail, _response.data!.accountNo);

    UserProvider.of(context).userName = ISEmpty(_response.data!.nickName)
        ? 'Unknown'
        : _response.data!.nickName;
    UserProvider.of(context).token = _response.data!.memberToken;
    UserProvider.of(context).avatar = _response.data!.avatar;
    UserProvider.of(context).createTime = _response.data!.createTime;
    UserProvider.of(context).country =
        ISEmpty(_response.data!.country) ? 'Unknown' : _response.data!.country;
    UserProvider.of(context).brith =
        ISEmpty(_response.data!.birthday) ? '--' : _response.data!.birthday;

    UserProvider.of(context).email =
        ISEmpty(_response.data!.accountNo) ? '' : _response.data!.accountNo;

    // 登录成功后绑定用户和推送的token
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    if (ISEmpty(gameUtil.firebaseToken)) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      gameUtil.firebaseToken = fcmToken ?? '';
    }
    updateAccountInfo({"firebaseToken": gameUtil.firebaseToken});
  }

/*苹果内购验证*/
  static Future<ApiResponse> applePayVertify(
      {String thirdPayNo = '',
      String productNo = '',
      String receiptDate = ''}) async {
    final _data = {
      'thirdPayNo': thirdPayNo,
      'productNo': productNo,
      'receiptDate': receiptDate,
      'packageName': 'com.potent.dangle',
    };
    final response =
        await HttpUtil.post('/api/pay/apple', _data, showLoading: true);
    return ApiResponse(success: response.success);
  }

/*谷歌内购验证*/
  static Future<ApiResponse> googlePayVertify(
      {String purchaseId = '',
      String productNo = '',
      String purchaseToken = ''}) async {
    final _data = {
      'purchaseId': purchaseId,
      'productNo': productNo,
      'purchaseToken': purchaseToken,
      'packageName': 'com.potent.dangle',
    };
    final response =
        await HttpUtil.post('/api/pay/google/sub', _data, showLoading: true);
    return ApiResponse(success: response.success);
  }

  /*获取订阅信息*/
  static Future<ApiResponse<SubscribeModel>> querySubscribeInfo() async {
    final response =
        await HttpUtil.get('/api/member/index', null, showLoading: false);
    SubscribeModel model = SubscribeModel();
    if (response.success && response.data['data'] != null) {
      final element = response.data['data'];
      final _map = element;
      final _payProductVoMap = element['payProductVo'] ?? {};
      model.subscribeStartDate = !ISEmpty(_map['subscribeStartDate'])
          ? _map['subscribeStartDate'].toString()
          : '';
      model.subscribeEndDate = !ISEmpty(_map['subscribeEndDate'])
          ? _map['subscribeEndDate'].toString()
          : '--';
      model.subscribeStatus =
          !ISEmpty(_map['subscribeStatus']) ? _map['subscribeStatus'] : 0;

      ApiPayProductVo productVo = ApiPayProductVo();
      productVo.productId = !ISEmpty(_payProductVoMap['productId'])
          ? _payProductVoMap['productId']
          : 0;
      productVo.productName = !ISEmpty(_payProductVoMap['productName'])
          ? _payProductVoMap['productName'].toString()
          : '';
      productVo.productNo = !ISEmpty(_payProductVoMap['productNo'])
          ? _payProductVoMap['productNo'].toString()
          : '';
      productVo.productPrice = !ISEmpty(_payProductVoMap['productPrice'])
          ? _payProductVoMap['productPrice']
          : 0;
      productVo.productRemark = !ISEmpty(_payProductVoMap['productRemark'])
          ? _payProductVoMap['productRemark'].toString()
          : '';
      productVo.productTerm = !ISEmpty(_payProductVoMap['productTerm'])
          ? _payProductVoMap['productTerm']
          : 0;
      productVo.productImage = !ISEmpty(_payProductVoMap['productImage'])
          ? _payProductVoMap['productImage'].toString()
          : '';
      model.productVo = productVo;

      return ApiResponse(success: response.success, data: model);
    } else {
      return ApiResponse(success: false);
    }
  }
}
