import 'package:code/services/http/airbattle.dart';
import 'package:code/utils/toast.dart';
import 'package:code/views/airbattle/activity_view.dart';
import 'package:flutter/material.dart';

typedef IntFunction = void Function(ActivityModel);

class ActivityListView extends StatefulWidget {
  IntFunction selectItem;

  ActivityListView({required this.selectItem});

  @override
  State<ActivityListView> createState() => _ActivityListViewState();
}

class _ActivityListViewState extends State<ActivityListView> {
  List<ActivityModel> _datas = [];
  ScrollController _scrollController = ScrollController();
 bool _hasMore = false;
 int _page = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    queryActivityListData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      print('上拉加载---');
      if(_hasMore){
        _page ++ ;
        queryActivityListData(loadMore: true);
      }
    }
  }

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
  Widget build(BuildContext context) {
    return ListView.separated(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              widget.selectItem(_datas[index]);
            },
            child: ActivityView(
              activityModel: _datas[index],
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 12,
            ),
        itemCount: _datas.length);
  }
}
