import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 用户信息模型
class UserModel extends ChangeNotifier {
  String _userName = 'Mike Jacy'; // 同户名
  String _avgPace = '1.0'; // 平均速度
  String _totalScore = '1000'; // 总得分
  String _totalTime = '4500'; // 总时常
  String _totalTimes = '100'; // 总次数
  bool _hasLogin = true; // 登录标识
  List<String> _overDataList = [];

  // get方法
  String get userName => _userName;

  String get avgPace => _avgPace;

  String get totalScore => _totalScore;

  String get totalTime => _totalTime;

  String get totalTimes => _totalTimes;

  bool get hasLogin => _hasLogin;

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

  set totalScore(String totalScore) {
    _totalScore = totalScore;
    notifyListeners();
  }

  set hasLogin(bool hasLogin) {
    _hasLogin = hasLogin;
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
