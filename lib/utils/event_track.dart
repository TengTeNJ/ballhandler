import 'package:code/constants/constants.dart';
import 'package:code/utils/global.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_it/get_it.dart';
const kPlayNow = 'playNow'; // play now
const kSelectMode = 'selectMode'; // 选择模式
const kSelectDataTime = 'selectDateTime'; // 选择数据的分析的时间区间
class EventTrackUtil{
  static  eventTrack(String key,Map<String,Object?> parameters) async{
     FirebaseAnalytics.instance.logEvent(name: key,parameters: parameters);
   }
   /*设置默认参数*/
   static Future<void> setDefaultParameters() async{
     GameUtil gameUtil = GetIt.instance<GameUtil>();
     final userName = await  NSUserDefault.getValue(kUserName);
     final email = await  NSUserDefault.getValue(kUserEmail);
     final  airbattle = gameUtil.isFromAirBattle;
     final  selectRecord = gameUtil.selectRecord;
     final  modelId = gameUtil.modelId;
     final  sceneId = gameUtil.gameScene.index +1;
    return await FirebaseAnalytics.instance
         .setDefaultEventParameters({
       'version': kAppVersion,
       'userName':userName.toString(),
       'email': email ?? '--',
       'airbattle': airbattle.toString(),
       'selectRecord': selectRecord.toString(),
       'modelId': modelId.toString(),
       'sceneId': sceneId.toString()
     });
   }
}