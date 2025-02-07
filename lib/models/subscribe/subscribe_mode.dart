class SubscribeMode{
  String title = '';
  bool basicAccess = false;
  bool membershipAccess = true;
  String basicTitle = '';
  String membershipTitle = '';
}
/*
* 会员和非会员的每项数据对比
* */
 List<SubscribeMode> getSubscribeModeList(){
  List<String> _titles = [
    'Leaderboard',
    'Air Battle',
    'Custom Play Modes',
    'Rewards Program',
    'Record & Replay',
    'Real-Time Feedback',
    'Performance Stats'
  ];
  List<String> _basicTitles = [
    '',
    '',
    '',
    '',
    '',
    '',
    '(basic)'
  ];
  List<String> _membershipTitles = [
    '',
    '',
    '',
    '',
    '',
    '',
    '(Premium)'
  ];
  List<bool> _basicAccesss = [
    false,
    false,
    false,
    false,
    false,
    true,
    true
  ];
  List<bool> _membershipAccesss = [
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ];
  List<SubscribeMode>_list = [];
  for(int i = 0; i < _titles.length; i++){
    SubscribeMode model = SubscribeMode();
    model.title = _titles[i];
    model.basicAccess = _basicAccesss[i];
    model.membershipAccess = _membershipAccesss[i];
    model.basicTitle = _basicTitles[i];
    model.membershipTitle = _membershipTitles[i];
    _list.add(model);
  }
  return _list;
}