import 'package:code/constants/constants.dart';
import 'package:code/services/http/profile.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:code/views/profile/integral_detail_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

import '../../utils/toast.dart';

class IntegralDetailController extends StatefulWidget {
  const IntegralDetailController({super.key});

  @override
  State<IntegralDetailController> createState() =>
      _IntegralDetailControllerState();
}

class _IntegralDetailControllerState extends State<IntegralDetailController> {
  List<IntegralModel> _datas = [];
  bool _hasMode = false;
  int _page = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    queryIntegralListData();
  }

/*监听页面滑动*/
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print('上拉加载---');
      if (_hasMode) {
        print('has more');
        _page++;
        queryIntegralListData(loadMore: true);
      }
    }
  }

  /*请求积分明细列表数据*/
  queryIntegralListData({bool loadMore = false}) async {
    if (loadMore) {
      TTToast.showLoading();
    }
    final _response = await Profile.queryIntegralListData(_page);
    if (_response.success && _response.data != null) {
      _datas.addAll(_response.data!.data);
      _hasMode = (_datas.length < _response.data!.count);
      setState(() {});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    // ClipRRect(
    //   borderRadius: BorderRadius.circular(26),
    //
    // ),
    return ClipRRect(
      child: Scaffold(
        backgroundColor: Constants.darkThemeColor,
        appBar: CustomAppBar(
          showBack: true,
          title: 'Points Details ',
        ),
        //  borderRadius: BorderRadius.circular(26),
        body: Container(
          color: Constants.darkThemeColor,
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: _datas.length > 0
                    ? ListView.separated(
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          if (index == _datas.length) {
                            return Container();
                          } else {
                            return IntegralView(
                              model: _datas[index],
                            );
                          }
                        },
                        separatorBuilder: (context, index) => Container(
                              margin: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                  color: hexStringToColor('#565674')),
                              height: 1,
                            ),
                        itemCount: _datas.length + 1)
                    : NoDataView(),
              )
            ],
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(26),
    );
  }
}
