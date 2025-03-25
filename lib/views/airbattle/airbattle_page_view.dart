import 'package:code/views/airbattle/airbattle_card_view.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../services/http/airbattle.dart';
import '../../utils/toast.dart';
class AirbattlePageView extends StatefulWidget {
  Function? scrollToPage;
  AirbattlePageView({super.key,required this.scrollToPage});

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
        if(_datas.isNotEmpty){
          ActivityModel _activity =  _datas.first;
          if(widget.scrollToPage != null){
            // 数据请求完成 主动传过去首个活动数据的活动id
            try {
              ActivityModel _dataModel = _datas.firstWhere((element) => element.activityStatus == 1);
              if(_dataModel != null){
                print('第一个进行中的活动的索引:${_datas.indexOf(_dataModel)}');
                _pageController.jumpToPage(_datas.indexOf(_dataModel));
               // widget.scrollToPage!(_dataModel.activityId,_dataModel.orignStartDate,_dataModel.orignEndDate);
              }
            } catch (e) {
              print('没有找到满足条件的元素');
            }
            widget.scrollToPage!(_activity.activityId,_activity.orignStartDate,_activity.orignEndDate);
          }
        }
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
      onPageChanged: (index){
        print('监听到滑动');
        if(widget.scrollToPage != null && index < _datas.length){
          // 数据请求完成 主动传过去首个活动数据的活动id
          widget.scrollToPage!(_datas[index].activityId,_datas[index].orignStartDate,_datas[index].orignEndDate);
        }
      },
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
