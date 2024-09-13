import 'package:code/constants/constants.dart';
import 'package:code/services/http/profile.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:code/views/participants/video_view.dart';
import 'package:flutter/material.dart';
import '../../utils/toast.dart';

class VideoListView extends StatefulWidget {
  const VideoListView({super.key});

  @override
  State<VideoListView> createState() => _VideoListViewState();
}

class _VideoListViewState extends State<VideoListView> {
  List<VideoModel> _datas = [];
  ScrollController _scrollController = ScrollController();
  bool _hasMore = false;
  int _page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    queryUserVideoListData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print('上拉加载---');
      if (_hasMore) {
        _page++;
        queryUserVideoListData(loadMore: true);
      }
    }
  }

  queryUserVideoListData({bool loadMore = false}) async {
    if (loadMore) {
      TTToast.showLoading();
    }
    final _response = await Profile.queryUserVideoListData(_page);
    if (_response.success && _response.data != null) {
      _datas.addAll(_response.data!.data);
      _hasMore = _datas.length < _response.data!.count;
      setState(() {});
    }
    if (loadMore) {
      TTToast.hideLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  _datas.length > 0 ? ListView.separated(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // widget.selectItem(_datas[index]);
            },
            child: Dismissible(
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {

              },
              confirmDismiss: (direction) async{
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: hexStringToColor('#3E3E55'),
                      title: Text('Confirm',style: TextStyle(color: Colors.white),),
                      content: Text('Are you sure you want to delete this video?',style: TextStyle(color: Colors.white),),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancel',style: TextStyle(color: Constants.baseStyleColor),),
                        ),
                        TextButton(
                          onPressed: () async{
                            final _response = await Profile.deleteVideo(_datas[index].trainId);
                            if(_response.success){
                              Navigator.of(context).pop(true);
                            }
                          },
                          child: Text('Delete',style: TextStyle(color: Constants.baseGreyStyleColor),),
                        ),
                      ],
                    );
                  },
                );
              },
              key: UniqueKey(),
              child: VideoView(
                videoModel: _datas[index],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 12,
            ),
        itemCount: _datas.length) :Transform.translate(child: NoDataView(),offset: Offset(0,-30),);
  }
}
