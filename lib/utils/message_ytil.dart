import 'package:flutter_app_badger/flutter_app_badger.dart';

import '../constants/constants.dart';
import 'nsuserdefault_util.dart';

class MessageUtil {
  static handleMessage(int unreadCount) async{
     NSUserDefault.setKeyValue(kUnreadMessageCount, unreadCount);
    // 更新角标
    if(unreadCount>=0){
      print('更新角标unreadCount=${unreadCount}');
      FlutterAppBadger.updateBadgeCount(unreadCount);
    }
  }
  static initMessageNadge() async{
    final _count = await NSUserDefault.getValue(kUnreadMessageCount) ?? 0;
    FlutterAppBadger.updateBadgeCount(_count);
  }

  static readMessage() async{
    final _count = await NSUserDefault.getValue(kUnreadMessageCount) ?? 0;
    int tempCount = _count - 1;
    if(tempCount <0 ){
      tempCount = 0;
    }
    NSUserDefault.setKeyValue(kUnreadMessageCount, tempCount);
    FlutterAppBadger.updateBadgeCount(tempCount);
  }

  static getOneMoreMessage() async{
    final _count = await NSUserDefault.getValue(kUnreadMessageCount) ?? 0;
    int tempCount = _count + 1;
    NSUserDefault.setKeyValue(kUnreadMessageCount, tempCount);
    FlutterAppBadger.updateBadgeCount(tempCount);
  }
}