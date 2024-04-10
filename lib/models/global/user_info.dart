import 'package:code/constants/constants.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 用户信息模型
class UserModel extends ChangeNotifier {
  String _userName = 'Guest'; // 同户名
  String _avgPace = '1.0'; // 平均速度
  String _totalScore = '1000'; // 总得分
  String _totalTime = '4500'; // 总时常
  String _totalTimes = '100'; // 总次数
  bool _hasLogin = false; // 登录标识
  String _token = ''; // 登录token
  String _createTime = '----'; // 账号的创建时间
  String _avatar = ''; // 头像
  List<String> _overDataList = [];
  String _email = ''; // 用户邮箱
  String _inputEmail = ''; // 用户输入的邮箱

  // get方法
  String get userName => _userName;

  String get avgPace => _avgPace;

  String get totalScore => _totalScore;

  String get totalTime => _totalTime;

  String get totalTimes => _totalTimes;

  bool get hasLogin => _token!=null && _token.length>0;

  String get token => _token;

  String get createTime => _createTime;

  String get avatar => _avatar;

  String get inputEmail => _inputEmail;

  String get email => _email;


  List<String> get overDataList {
    _overDataList.clear();
    _overDataList.add(this.avgPace);
    _overDataList.add(this.totalScore);
    _overDataList.add(this.totalTime);
    _overDataList.add(this.totalTimes);
    return _overDataList;
  }

  // set方法
  set userName(String name) {
    _userName = name;
    notifyListeners();
  }

  set avgPace(String avgPace) {
    _avgPace = avgPace;
    notifyListeners();
  }

  set totalTime(String totalTime) {
    _totalTime = totalTime;
    notifyListeners();
  }

  set totalTimes(String totalTimes) {
    _totalTimes = totalTimes;
    notifyListeners();
  }

  set totalScore(String totalScore) {
    _totalScore = totalScore;
    notifyListeners();
  }

  set hasLogin(bool hasLogin) {
    _hasLogin = hasLogin;
    notifyListeners();
  }

  set createTime(String createTime) {
    _createTime = createTime;
    notifyListeners();
  }

  set token(String token) {
    _token = token;
    notifyListeners();
  }

  set avatar(String avatar) {
    _avatar = avatar;
    notifyListeners();
  }

  set inputEmail(String inputEmail) {
    _inputEmail = inputEmail;
  }

  set email(String email) {
    _email = email;
    notifyListeners();
  }
}

// 创建一个全局的Provider
class UserProvider extends StatelessWidget {
  final Widget child;

  UserProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: child,
    );
  }

  static UserModel of(BuildContext context) {
    return Provider.of<UserModel>(context, listen: false);
  }

}
