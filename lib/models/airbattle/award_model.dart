import 'package:code/utils/string_util.dart';

enum AwardStatu { noViewed, viewed, sent }

class AwardModel {
  String title = 'Air Battle  Champion';
  String statu = 'No Viewed';
  String time = '----';
  String airbattleTitle = 'ZIGZAG Challenge';
  int rewardStatus = 0; // 奖励状态 0未读、1已读、2已发送邮件
  double rewardMoney = 0; // 奖励金额
  String createTime = '--';
  String activityName = ''; // 活动名称
  String get statuString {
    if (this.rewardStatus == 0) {
      return 'No Viewed';
    } else if (this.rewardStatus == 1) {
      return 'Viewed';
    } else if (this.rewardStatus == 2) {
      return 'Sent';
    }
    return 'No Viewed';
  }

  String get des {
    return 'POTENT HOCKSY Amazon ' + this.rewardMoney.toString() + '\$ Coupons';
  }

  String get showTime{
   return  StringUtil.serviceStringToShowMinuteString(this.createTime);
  }
}
