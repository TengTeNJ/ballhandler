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
    String formattedDate = DateFormat('MMMM.dd.yyyy HH:mm').format(now);
    return formattedDate;
  }

  static String dateToBrithString(DateTime date) {
    String formattedDate = DateFormat('MMMM dd,yyyy').format(date);
    return formattedDate;
  }

  /*时间字符串转换为日期*/
  static DateTime stringToDate(String timeString) {
    DateTime dateTime = DateTime.parse(timeString);
    return dateTime;
  }

  /*服务器返回的时间字符串转换为界面上需要展示的时间格式字符串*/
  static String serviceStringToShowDateString(String timeString){
    print('timeString=${timeString}');
    DateTime dateTime = stringToDate(timeString);
    print('dateTime=${dateTime}');
    String tempString = dateToBrithString(dateTime);
    print('tempString=${tempString}');
    return tempString;
  }
}
