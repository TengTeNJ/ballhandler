import 'package:code/views/airbattle/airbattle_card_view.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../services/http/airbattle.dart';
import '../../utils/toast.dart';
class AirbattlePageView extends StatefulWidget {
  const AirbattlePageView({super.key});

  @override
  State<AirbattlePageView> createState() => _AirbattlePageViewState();
}

class _AirbattlePageViewState extends State<AirbattlePageView> {
  List<ActivityModel> _datas = [];
  bool _hasMore = false;
  int _page = 1;
  late PageController _pageController;
  int _currentIndex = 0;
  queryActivityListData({bool loadMore = false}) async {
    if(loadMore){
      TTToast.showLoading();
    }
    final _response = await AirBattle.queryAllActivityListData(_page);
    if (_response.success && _response.data != null) {
      _datas.addAll(_response.data!.data);
      _hasMore = _datas.length < _response.data!.count;
      if(mounted){
        setState(() {});
      }
    }
    if(loadMore){
      TTToast.hideLoading();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _currentIndex,viewportFraction: 0.98);
    queryActivityListData();
    
  }
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        padEnds:false,
        controller: _pageController,
        itemCount: _datas.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 5),
            child: AirbattleCardView(activityModel: _datas[index]),
          );
        });
  }
}
