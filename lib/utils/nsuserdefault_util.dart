import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NSUserDefault {
  static Future<void> setKeyValue<T>(String key, T value) async {
    final SharedPreferences _preferences =
        await SharedPreferences.getInstance();
    // 根据类型保存对象
    if (value is String) {
      await _preferences.setString(key, value as String);
    } else if (value is int) {
      await _preferences.setInt(key, value as int);
    } else if (value is bool) {
      await _preferences.setBool(key, value as bool);
    } else if (value is double) {
      await _preferences.setDouble(key, value as double);
    } else if (value is List<String>) {
      await _preferences.setStringList(key, value as List<String>);
    }
  }

  // 泛型方法，用于从SharedPreferences获取对象
  static Future<T?> getValue<T>(String key) async {
    final SharedPreferences _preferences =
        await SharedPreferences.getInstance();
    // 根据类型获取对象
    final value = _preferences.containsKey(key) ? _preferences.get(key) : null;
    if (value is String) {
      return value as T;
    } else if (value is int) {
      return value as T;
    } else if (value is bool) {
      return value as T;
    } else if (value is double) {
      return value as T;
    } else if (value is List<String>) {
      return value as T;
    }
    return null;
  }

  // 清除指定key的值
  Future<void> clearValue(String key) async {
    final SharedPreferences _preferences =
        await SharedPreferences.getInstance();
    await _preferences.remove(key);
  }

  static Future<void> initUserInfo(BuildContext context) async{
    final _nickName = await NSUserDefault.getValue<String>(kUserName);
    final _ava = await NSUserDefault.getValue<String>(kAvatar);
    final _token = await NSUserDefault.getValue<String>(kAccessToken);
    final _email = await NSUserDefault.getValue<String>(kUserEmail);
    final _brith = await NSUserDefault.getValue<String>(kBrithDay);
    final _country = await NSUserDefault.getValue<String>(kCountry);

    if(_nickName != null){
      UserProvider.of(context).userName = _nickName;
    }
    if(_ava != null){
      UserProvider.of(context).avatar = _ava;
    }
    if(_token!=null){
      UserProvider.of(context).token = _token;
    }
    if(_email!=null){
      UserProvider.of(context).email = _email;
    }
    if(_brith!=null){
      UserProvider.of(context).brith = _brith;
    }
    if(_country!=null){
      UserProvider.of(context).country = _country;
    }
  }
  /*清空用户信息*/
  static clearUserInfo(BuildContext context){
    NSUserDefault.setKeyValue(kUserEmail, '');
    NSUserDefault.setKeyValue(kAccessToken, '');
    NSUserDefault.setKeyValue(kUserName, 'Guest');
    NSUserDefault.setKeyValue(kAvatar, '');
   initUserInfo(context);
  }
}
