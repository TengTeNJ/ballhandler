
enum ActivityStatu {
  notStart,
  enderWay,
  end
}

class ActivityModel{
  String title = 'How Many IN 45';
  String des = 'POTENT Digital Stickhandling T';
  String startTime = 'JULY 2024';
  String statuString = 'Under Way';
  ActivityStatu _statu = ActivityStatu.notStart;

  ActivityStatu get statu => _statu;
  set  statu(ActivityStatu statu ){
    _statu = statu;
  }
}