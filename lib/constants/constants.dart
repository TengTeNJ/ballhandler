import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  //  屏幕宽度
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  //  屏幕高度
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // 状态栏高度
  static double statusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  // 底部导航栏的高度，一般时动态获取的
  static Future<double> bottomBarHeight(BuildContext context) async {
    return MediaQuery.of(context).padding.bottom;
  }

  // 用于表示工具栏的默认高度，在Material Design中通常为56像素。工具栏用于显示应用程序的标题、操作按钮等内容。
  static double appBarHeight = kToolbarHeight;

  // 底部导航栏高度 默认为56像素
  static double tabBarHeight = kBottomNavigationBarHeight;

  static String privacyText =
      'To ensure that personal information of players are respected and protected.  I give explicit authorization and consent for their use in commercial promotion or publication on social media. Such materials can only be legally used after obtaining explicit written consent.';

  static Color darkThemeColor = Color.fromRGBO(38, 38, 48, 1);
  static Color darkThemeOpacityColor = Color.fromRGBO(41, 41, 54, 0.24);
  static Color baseStyleColor = Color.fromRGBO(248, 133, 11, 1);
  static Color baseGreyStyleColor = Color.fromRGBO(177, 177, 177, 1);
  static Color darkControllerColor = Color.fromRGBO(57, 57, 75, 1);
  static Color baseControllerColor = Color.fromRGBO(41, 41, 54, 1);
  static Color baseLightBlueColor = Color.fromRGBO(52, 59, 247, 1);
  static Color baseLightRedColor = Color.fromRGBO(255, 45, 55, 1);

  static Text regularBaseTextWidget(String text, double fontSize,
      {int maxLines = 1,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
          color: Constants.baseStyleColor,
          fontSize: fontSize),
    );
  }

  static Text regularGreyTextWidget(String text, double fontSize,
      {int? maxLines,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0,
      TextOverflow? overflow}) {
    return Text(
      maxLines: maxLines ?? null,
      textAlign: textAlign,
      text,
      style: TextStyle(
          overflow: overflow,
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
          color: Constants.baseGreyStyleColor,
          fontSize: fontSize),
    );
  }

  static Text regularWhiteTextWidget(String text, double fontSize,
      {int? maxLines,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      maxLines: maxLines ?? null,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontSize: fontSize),
    );
  }

  static Text mediumBaseTextWidget(String text, double fontSize,
      {int maxLines = 1,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w500,
          color: Constants.baseStyleColor,
          fontSize: fontSize),
    );
  }

  static Text mediumGreyTextWidget(String text, double fontSize,
      {int? maxLines,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w500,
          color: Constants.baseGreyStyleColor,
          fontSize: fontSize),
    );
  }

  static Text mediumBaseGreyTextWidget(String text, double fontSize,
      {int? maxLines,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w500,
          color: Constants.baseControllerColor,
          fontSize: fontSize),
    );
  }

  static Text mediumWhiteTextWidget(String text, double fontSize,
      {int maxLines = 1,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: fontSize),
    );
  }

  static Text boldWhiteTextWidget(String text, double fontSize,
      {int? maxLines,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines,
      text,
      style: TextStyle(
        height: height,
        fontFamily: 'SanFranciscoDisplay',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: fontSize,
      ),
    );
  }

  static Text boldBlackTextWidget(String text, double fontSize,
      {int maxLines = 1,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(28, 30, 33, 1.0),
          fontSize: fontSize),
    );
  }

  static Text boldBaseTextWidget(String text, double fontSize,
      {int maxLines = 1,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay4',
          fontWeight: FontWeight.bold,
          color: Constants.baseStyleColor,
          fontSize: fontSize),
    );
  }

  static Text customTextWidget(String text, double fontSize, String color,
      {int? maxLines,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0,
      FontWeight? fontWeight,
      TextOverflow? overflow}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines ?? null,
      text,
      style: TextStyle(
          overflow: overflow,
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: fontWeight,
          color: hexStringToColor(color),
          fontSize: fontSize),
    );
  }

  // DS-DIGI
  static Text digiRegularWhiteTextWidget(String text, double fontSize,
      {int maxLines = 1,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'DS-DIGI',
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontSize: fontSize),
    );
  }

  static TextStyle placeHolderStyle() {
    return TextStyle(
        color: Color.fromRGBO(132, 132, 132, 1.0),
        fontFamily: 'SemiBold',
        fontSize: 16,
        fontWeight: FontWeight.w600);
  }

  static double fontSize(BuildContext context, double size) {
    return Constants.screenWidth(context) / 375 * size;
  }
}

/*Preferences key*/
const kUserName = 'nickName';
const kAvatar = 'avatar';
const kAccessToken = 'token';
const kInputEmail = 'inputEmail';
const kUserEmail = 'userEmail';
const kBrithDay = 'brithDay';
const kCountry = 'countryArea';
const kUnreadMessageCount = 'unreadMessageCount'; // 未读消息的数量
const kShowLaunch = 'showLaunchPage'; // 是否展示启动介绍页的标识

/**蓝牙设备相关的信息**/
const kBLEDevice_Name = 'Myspeedz';
const kBLEDevice_NewName = 'Stickhandling'; // StarShots Stickhandling
// const kFiveBallHandler_Name = 'Stickhandling'; // 五节控球器的名称
const kFiveBallHandler_Name = 'Stickhandling'; // 五节控球器的名称
const kThreeBallHandler_Name = 'Razor Dangler 2.0'; // 三节控球器的名称
const k270_Name_Release = 'Ultimater Dangler'; // 270度
const k270_Name = 'Dangler-M'; // 270度 蓝牙设备名称

const kBLEDevice_OldName = 'Tv511u-E4247823';
const kBLE_SERVICE_NOTIFY_UUID = "ffe0";
const kBLE_SERVICE_WRITER_UUID = "ffe5";
const kBLE_CHARACTERISTIC_NOTIFY_UUID = "ffe4";
const kBLE_CHARACTERISTIC_WRITER_UUID = "ffe9";
const kBLE_270_SERVICE_UUID = "fff0";
const kBLE_270_CHARACTERISTIC_NOTIFY_UUID = "fff1";
const kBLE_270_CHARACTERISTIC_WRITER_UUID = "fff2";

const kPageLimit = 10; // 数据分页每页显示的数据量

const kTestRobotName = '270 Test Robot'; //StarShots 270 Test Robo
const kBLE_SERVICE_ROBOT_UUID = "181a";
const kBLE_ROBOT_CHARACTERISTIC_NOTIFY_UUID = "2a6e";
const kBLE_ROBOT_CHARACTERISTIC_WRITER_UUID = "2a6f";

const kBLEDevice_Names = [
  kBLEDevice_Name,
  kBLEDevice_NewName,
  kFiveBallHandler_Name,
  kThreeBallHandler_Name,
  k270_Name,
  kTestRobotName
];

const kBLEDevice_ReleaseNames = [
  kFiveBallHandler_Name,
  k270_Name,
  kThreeBallHandler_Name,
  kTestRobotName,
];

const kTrainingMode_ReleaseNames = [
  kFiveBallHandler_Name,
  k270_Name_Release,
  kThreeBallHandler_Name,
  kTestRobotName,
];

const kBLEDataFrameHeader = 0xA5; // 蓝牙数据帧头
const kBLEDataFramerFoot = 0xAA; // 蓝牙数据尾

const String kBaseUrl_Dev = 'http://120.26.79.141:91'; // 测试环境地址
// 13.49.0.47:91
const String kBaseUrl_Pro = 'http://13.49.0.47:91'; // 生产环境地址

const kDataBaseTableName = 'game_data_table'; // 数据库的表名
const kDataBaseTVideoableName = 'video_table'; // 视频路径数据库的表名
const kDataBaseSubscripeName = 'subscription'; // 订阅

const kGameDuration = 45; // 游戏时常

double kFontSize(BuildContext context, double size) {
  // double font =Constants.screenWidth(context) / 375 * size;
  return size;
}

double baseMargin(BuildContext context, double size) {
  // double scale =Constants.screenWidth(context) / 375 ;
  return size;
}

//*判断对象是否为空以及字符串长度为0*/
bool ISEmpty(Object? obj) {
  if (obj == null) {
    return true;
  }
  if (obj is String) {
    return obj.length == 0;
  }
  return false;
}

// 全局监听
const kLoginSucess = 'login_success'; // 登录成功
const kFinishGame = 'finish_game'; // 游戏完成，保存数据成功
const kSignOut = 'sign_out'; // 退出登录
const kBackFromFinish = 'back_from_finish'; // 从finish页面返回
const kMessageRead = 'read_message'; // 阅读消息
const kGetMessage = 'get_message'; // 收到消息
const kIntegralChange = 'change_integral'; // 积分兑换
const kCurrentDeviceInfoChange = 'current_device_info_change'; // 当前游戏设备信息改变
const kCurrentDeviceDisconnected = 'current_device_disconnected'; // 当前游戏设备断开连接
const kPopSubscribeDialog = 'pop_subscribe_dialog'; // 主动弹出订阅弹窗
const kPopSubscribeLate = 'pop_subscribe_dialog_late'; // 稍后订阅
const kCurrent270DeviceInfoChange =
    'current_270_device_info_change'; // 当前270游戏设备信息改变
const kGameReady = 'game_ready'; // 游戏
const kInitiativeDisconnect = 'initiative_disconnect'; // 主动断开
const kDeviceConnected = 'device_connected'; // 设备连接成功
const kInitiativeDisconnectUli = 'initiative_disconnect_uli'; // 主动断开
const kInitiativeDisconnectFive = 'initiative_disconnect_five'; // 主动断开
const kCurrentDeviceDisconnectedUli = 'current_device_disconnected_uli'; // 当前游戏设备断开连接
const kCurrentDeviceDisconnectedFive = 'current_device_disconnected_five'; // 当前游戏设备断开连接
const kRobotStatuChange = 'robot_statu_change'; // 机器人状态改变

const Map<String, Map<String, String>> kGameSceneAndModelMap = {
  "1": {
    "7": "ZIGZAG Challenge",
    "1": "2 Challenge",
    "2": "L Challenge",
    "3": "OMEGA Challenge",
    "6": "Straight line Challenge",
    "4": "Pentagon Challenge",
    "5": "SMILE Challenge",
  },
  "2": {
    "1": "P1 Mode",
    "2": "P2 Mode",
    "3": " FREE Mode",
  },
  "3": {
    "7": "ZIGZAG Challenge",
    "1": "2 Challenge",
    "2": "L Challenge",
    "3": "OMEGA Challenge",
    "6": "Straight line Challenge",
    "4": "Pentagon Challenge",
    "5": "SMILE Challenge",
  }
}; // 游戏场景和模式映射表

const k270ProductImageScale = 1445 / 737; // 270产品图片宽高比

const kUserVideoMaxCount = 100; // 视频的最大数量

const kAppVersion = '202405131652';

const Map<int, int> kLighMap = {1: 4, 2: 5, 3: 1, 4: 2, 5: 3}; // 灯光映射表

const Map<int, Map<String, String>> p3Maps = {
  0: {
    'image': 'WideDekes.apng',
    'title': 'Wide Dekes',
    'des':
        'Navigate 15 seconds in each of the three two-pad zones , engaging with 1 or 2 red lights randomly up across two pads, each worth 2 points, and dodging a single blue \'defender\' light, demanding quick reactions and agile decision-making.'
  },
  1: {
    'image': 'zigzag.apng',
    'title': 'Ziazag',
    'des':
        'Sharpen your control of the puck with zigzag-handling patterns. Follow the lights to trainspeed and control with forehand and backhand.'
  },
  2: {
    'image': 'ToeDrag.apng',
    'title': 'Toe Drag',
    'des':
        'Master the full workout area, applying a wide array of advanced techniques to outmaneuver defenders and navigate complex scenarios, mirroring the unpredictability of real-game situations..'
  },
  3: {
    'image': 'Triangles.apng',
    'title': 'Triangles',
    'des':
        'Tackle Triangles sequences in backhand side, front and fronthand side zones across the full 270-degree workout area Dodge blue \'defenders\' and weave through shifting red lights to enhance agility, puck control, and strategic evasion skills'
  },
  4: {
    'image': 'Backhand.apng',
    'title': 'Backhand',
    'des':
        'For Backhand training in backhand side and fronthand side engaging with 1 or 2 red lights randomly up across two pads, each worth 2 points, and dodging a single blue \'defender\' light, demanding quick reactions and agile decision-making.'
  },
  5: {
    'image': 'TTL.apng',
    'title': 'Through the legs',
    'des':
        ' For through-the-legs hockey drill, there will be 3 blue defender dots and 1 red target. You will need to weave through the legs, in and around the blue defenders to score points. This will enhance your ability to stickhandle between defenders legs or blade. Improve precision and reaction time in game-like situations.To add complexity, try adding a fake to one direction and through the legs in the other. '
  },
  6: {
    'image': 'Figure8.apng',
    'title': 'Figure 8',
    'des':
        'Tackle figure-8 sequences in backhand side, front and fronthand side zones across the full 270-degree workout area, honing precision stickhandling in tight spaces. Dodge blue \'defenders\' and weave through shifting red lights to enhance agility, puck control, and strategic evasion skills'
  },
  7: {
    'image': 'onehand.apng',
    'title': 'One handed',
    'des':
        'For one-handed training,practice from positional puck control to figure 8,use top hand on your stick,keeping it close to your body to maximize control.Focus on wrist strength by dribbling the puck with varying speeds and directions.Incorporate cone weaving to enhance dexterity and stick handling precision,ensuring to switch hands periodically for balanced training'
  },
}; // 270 P3模式 guide数据map映射表

// const Set<String> kProductIds = <String>{'hockey_101', 'hockey_5'}; // 订阅产品id
const Set<String> kProductIds = <String>{'hockey_02', 'five_1'}; // 订阅产品id
const Map<int, Map<int, int>> kBoardMap = {
  0: {3: 9, 0: 10, 1: 11, 2: 12},
  1: {3: 0, 0: 2, 1: 3, 2: 1},
  2: {3: 4},
  3: {3: 5, 0: 7, 1: 8, 2: 6},
  4: {
    3: 13,
  },
  5: {3: 14, 0: 15, 1: 17, 2: 16},
}; // 灯板编号以及灯板上每个灯的数据索引和UI索引的映射表

const Map<int, Map<String, int>> kP3IndexAndDurationMap = {
  // 和P1保持一致
  0: {
    'second': 30,
    'duration': 30000,
    'frequency': 3500,
  },
  1: {
    'second': 30,
    'duration': 30000,
    'frequency': 3500,
  },
  // 和P1保持一致
  2: {
    'second': 30,
    'duration': 30000,
    'frequency': 3500,
  },
  3: {
    'second': 30,
    'duration': 30000,
    'frequency': 3500,
  },
  4: {
    'second': 30,
    'duration': 30000,
    'frequency': 3500,
  },
  5: {
    'second': 30,
    'duration': 30000,
    'frequency': 3500,
  },
  // 和P1保持一致
  6: {
    'second': 30,
    'duration': 90000,
    'frequency': 3500,
  },
  7: {
    'second': 30,
    'duration': 30000,
    'frequency': 3500,
  },
};

const kP1Duration = 90; // 270设备P1模式的游戏时长
const kP2Duration = 120; // 270设备P2模式的游戏时长

const Map<int, int> kP3DataAndProductIndexMap = {
  0:1,
  1:1,
  2:2,
  3:3,
  4:5,
  5:6
}; // 270灯板的蓝牙数据索引和产品标签上的实际索引的映射表

const Map<String,int> kBoardIndexToRobotIndexMap = {
  '13':1,
  '12':2,
  '10':3,
  '11':4,
  '23':5,
  '32':6,
  '33':7,
  '30':8,
  '31':9,
  '03':10,
  '00':11,
  '02':12,
  '01':13,
  '43':14,
  '53':15,
  '50':16,
  '52':17,
  '51':18,
};
