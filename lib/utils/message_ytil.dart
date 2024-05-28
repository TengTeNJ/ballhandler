import 'package:flutter_app_badger/flutter_app_badger.dart';

import '../constants/constants.dart';
import 'nsuserdefault_util.dart';

class MessageUtil {
  /*根据接口返回未读的消息的数量进行处理角标*/
  static handleMessage(int unreadCount) async{
     NSUserDefault.setKeyValue(kUnreadMessageCount, unreadCount);
    // 更新角标
    if(unreadCount>=0){
      print('更新角标unreadCount=${unreadCount}');
      FlutterAppBadger.updateBadgeCount(unreadCount);
    }
  }

  /*根本本地数据初始化应用后角标*/
  static initMessageNadge() async{
    final _count = await NSUserDefault.getValue(kUnreadMessageCount) ?? 0;
    FlutterAppBadger.updateBadgeCount(_count);
  }

/*
* 读消息后更新角标*/
  static readMessage() async{
    final _count = await NSUserDefault.getValue(kUnreadMessageCount) ?? 0;
    int tempCount = _count - 1;
    if(tempCount <0 ){
      tempCount = 0;
    }
    NSUserDefault.setKeyValue(kUnreadMessageCount, tempCount);
    FlutterAppBadger.updateBadgeCount(tempCount);
  }

/*收到新的消息后更新角标*/
  static getOneMoreMessage() async{
    final _count = await NSUserDefault.getValue(kUnreadMessageCount) ?? 0;
    int tempCount = _count + 1;
    NSUserDefault.setKeyValue(kUnreadMessageCount, tempCount);
    FlutterAppBadger.updateBadgeCount(tempCount);
  }
}