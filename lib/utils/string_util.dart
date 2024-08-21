import 'package:code/utils/ble_ultimate_service_data.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart'; // 导入intl包

class StringUtil {
  /*邮箱校验*/
  static bool isValidEmail(String email) {
    // 正则表达式模式，用于匹配电子邮件地址
    // 该模式可以匹配大多数常见的电子邮件地址格式，但并非所有
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

/*密码校验*/
  static bool isValidPassword(String password) {
    // 正则表达式模式，用于匹配密码格式
    // 密码至少8位，包含字母、数字和特殊符号中的至少两种
    String pattern =
        r'^(?=.*[A-Za-z])(?=.*\d|.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  /*昵称校验*/
  static bool isValidNickname(String nickname) {
    // 正则表达式模式，用于匹配昵称格式
    // 昵称只能包含字母和数字，且最长为16位
    String pattern = r'^[a-zA-Z0-9]{1,16}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(nickname);
  }

  /*时间转字符串*/
  static String dateTimeToString(DateTime datetime) {
    String _string = formatDate(datetime, [yyyy, '-', mm, '-', dd]);
    return _string;
  }

  static String dateToString(DateTime date) {
    String formattedDate = DateFormat('yyyy/MM/dd').format(date);
    return formattedDate;
  }

  static String dateToGameTimeString() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    return formattedDate;
  }

  static String dateToBrithString(DateTime date) {
    String formattedDate = DateFormat('MMMM dd,yyyy').format(date);
    return formattedDate;
  }

  /*时间字符串转换为日期*/
  static DateTime stringToDate(String timeString) {
    print('timeString=${timeString}');
    if(timeString.contains('/')){
      timeString = timeString.replaceAll('/', '-');
    }
    DateTime dateTime = DateTime.parse(timeString);
    return dateTime;
  }

  /*UI上展示的时间字符串转换为DateTime*/
  static DateTime showTimeStringToDate(String timeString) {
    final DateFormat formatter = DateFormat("MMMM dd,yyyy HH:mm'");
    DateTime dateTime = formatter.parse(timeString);
    return dateTime;
  }

  static DateTime showTimeStringToDateNotMinute(String timeString) {
    final DateFormat formatter = DateFormat("MMMM dd,yyyy'");
    DateTime dateTime = formatter.parse(timeString);
    return dateTime;
  }


  /*服务器返回的时间字符串转换为界面上需要展示的时间格式字符串*/
  static String serviceStringToShowDateString(String timeString) {
    try {
      DateTime dateTime = stringToDate(timeString);
      String tempString = dateToBrithString(dateTime);
      return tempString;
    } catch (error) {
      return '-';
    }
  }

  /*服务器返回的时间字符串转换为我的活动界面上需要展示的时间格式字符串*/
  static String serviceStringToShowMyActivityDateString(String timeString) {
    try {
      DateTime dateTime = stringToDate(timeString);
      String formattedDate = DateFormat('MMMM yyyy').format(dateTime);
      return formattedDate;
    } catch (error) {
      return '-';
    }
  }

  /*数据分析页面自定义时间展示*/
  static String serviceStringMyStatuDateString(String timeString) {
    try {
      DateTime dateTime = stringToDate(timeString);
      String formattedDate = DateFormat('MMMM dd').format(dateTime);
      return formattedDate;
    } catch (error) {
      return '-';
    }
  }

  static String serviceStringToShowMinuteString(String timeString) {
    print('timeString = ${timeString}');
    try {
      DateTime dateTime = stringToDate(timeString);
      String formattedDate = DateFormat('MMMM dd,yyyy HH:mm').format(dateTime);
      return formattedDate;
    } catch (error) {
      return '-';
    }
  }

  /*灯光掩码转为状态
  上面每个掩码占据2BITS，
  取值：
  0b00-关灯;
  0b01-红灯;
  0b10-蓝灯;
  0b11-红灯+蓝灯。*/
  static BleULTimateLighStatu lightToStatu(String lightStatu){
   if(lightStatu == '00'){
     return BleULTimateLighStatu.close;
   }else if(lightStatu == '01'){
     return BleULTimateLighStatu.red;
   }else if(lightStatu == '10'){
     return BleULTimateLighStatu.blue;
   }else if(lightStatu == '11'){
     return BleULTimateLighStatu.redAndBlue;
   }
   return BleULTimateLighStatu.close;
  }

  /*10进制转换为2进制字符串*/
 static String decimalToBinary(int decimal) {
    if (decimal < 0) {
      return "负数不能直接转换为二进制";
    }
    String binary = '';
    while (decimal > 0) {
      binary = (decimal % 2).toString() + binary;
      decimal = decimal ~/ 2;
    }
    binary = binary.padLeft(8,'0');
    return binary;
  }

  /*二进制字符串转换成十进制*/
  static int binaryStringToDecimal(String binaryString) {
    // 将二进制字符串转换为十进制数
    return int.parse(binaryString, radix: 2);
  }
/*记录两个时间点的时间差*/
 static  int differenceInSeconds(DateTime? startTime , DateTime? endTime) {
   if(startTime == null || endTime == null){
     return 0;
   }
    final Duration duration = endTime.difference(startTime);
    return duration.inSeconds.ceil(); // 计算秒数并向上取整
  }
}
