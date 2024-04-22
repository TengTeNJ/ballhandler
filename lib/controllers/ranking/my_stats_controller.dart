import 'package:code/constants/constants.dart';
import 'package:code/models/mystats/my_stats_model.dart';
import 'package:code/services/http/rank.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/views/airbattle/my_stats_bar_chart_view.dart';
import 'package:code/views/airbattle/my_stats_grid_list_view.dart';
import 'package:code/views/airbattle/my_stats_line_area_view.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyStatsController extends StatefulWidget {
  const MyStatsController({super.key});

  @override
  State<MyStatsController> createState() => _MyStatsControllerState();
}

class _MyStatsControllerState extends State<MyStatsController> {
  List<MyStatsModel> datas = [];
  List<MyStatsModel> barViewDatas = [];
  AnalyzeDataModel _analyzeDataModelmodel = AnalyzeDataModel();
  List<String> _titles = [
    'Last 7 days',
    'Last 30 days',
    'Last 90 days',
    'Custom'
  ];
  int _timeIndex = 0;
  num temp = 2;
  String _start = '';
  String _end = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  /*获取折线图、柱状图、对比分析数据*/
  initData() async {
    final List<Future<dynamic>> futures = [];
    futures.add(Rank.queryComparetData(null, null, '1'));
    futures.add(Rank.queryLineViewData(null, null));
    futures.add(Rank.queryBarViewData());
    final _responses = await Future.wait(futures);
    // 对比数据
    final _compareResponse = _responses[0];
    if (_compareResponse.success && _compareResponse.data != null) {
      _analyzeDataModelmodel = _compareResponse.data!;
    }
    // 折线图数据
    final _lineResponse = _responses[1];
    if (_lineResponse.success) {
      if (_lineResponse.data != null && _lineResponse.data!.length > 0) {
        datas.addAll(_lineResponse.data!);
      }
    }
    // 柱状图数据
    final _response = _responses[2];
    if (_response.success) {
      if (_response.data != null && _response.data!.length > 0) {
        barViewDatas.addAll(_response.data!);
      }
    }
    setState(() {});
  }

/*根据时间范围刷新数据*/
  changeTimeArea(String? startTime, String? endTime, String selectType) async {
    final List<Future<dynamic>> futures = [];
    futures.add(Rank.queryComparetData(startTime, endTime, selectType));
    futures.add(Rank.queryLineViewData(startTime, endTime));
    final _responses = await Future.wait(futures);
    // 对比数据
    final _compareResponse = _responses[0];
    if (_compareResponse.success && _compareResponse.data != null) {
      _analyzeDataModelmodel = _compareResponse.data!;
    }
    // 折线图数据
    final _lineResponse = _responses[1];
    if (_lineResponse.success) {
      if (_lineResponse.data != null && _lineResponse.data!.length > 0) {
        if (datas.length > 0) {
          datas.clear();
        }
        datas.addAll(_lineResponse.data!);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(
        showBack: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Constants.boldWhiteTextWidget('My Stats', kFontSize(context, 30)),
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image(
                        image:
                            AssetImage('images/participants/icon_orange.png'),
                        width: 32,
                        height: 32,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Constants.mediumWhiteTextWidget(
                          'Training Model', kFontSize(context, 16)),
                    ],
                  ),
                  Row(
                    children: [
                      Image(
                        image: AssetImage('images/participants/rank.png'),
                        width: 12,
                        height: 16,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Constants.mediumWhiteTextWidget(
                          'RANK  ${_analyzeDataModelmodel.rankNumber}',
                          kFontSize(context, 16)),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
              MyStatsGridListView(
                model: _analyzeDataModelmodel,
                selectType: _timeIndex,
              ),
              // grid view
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Constants.regularWhiteTextWidget(
                      'Training Growth', kFontSize(context, 14)),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // 时间选择弹窗
                      TTDialog.timeSelect(context, (startTime, endTime, index) {
                        _timeIndex = index;
                        _start = startTime;
                        _end = endTime;
                        if(index==3){
                          _titles[_titles.length-1] = "${_start}-${_end}";
                          setState(() {

                          });
                        }
                        changeTimeArea(
                            endTime, startTime, (index + 1).toString());
                      }, index: _timeIndex,start: _start.length > 0 ? _start : null,end: _end.length > 0 ? _end : null);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Constants.darkThemeColor,
                        border: Border.all(
                            color: hexStringToColor('#707070'), width: 1),
                      ),
                      padding: EdgeInsets.only(
                          top: 4, bottom: 4, left: 16, right: 16),
                      child: Row(
                        children: [
                          Constants.regularWhiteTextWidget(
                              _titles[_timeIndex], 14),
                          SizedBox(
                            width: 8,
                          ),
                          Image(
                            image: AssetImage('images/ranking/down.png'),
                            width: 8,
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 36,
              ),
              Container(
                height: (temp / 0.2).ceil() * 36 + 36,
                child: LineAreaView(datas),
              ),
              SizedBox(
                height: 40,
              ),
              Constants.regularWhiteTextWidget(
                  'Best In History', kFontSize(context, 14)),
              SizedBox(
                height: 36,
              ),
              Container(
                height: (2 / 0.2).ceil() * 36 + 36,
                child: BarView(barViewDatas),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*折线图*/
Widget LineAreaView(List<MyStatsModel> datas) {
  if(datas.length == 0){
    return NoDataView();
  }
  int page = 1;
  if (datas.length > 30) {
    page = (datas.length / 30).ceil();
  }
  return PageView.builder(
    itemBuilder: (context, index) {
      return MyStatsLineAreaView(
          datas: datas.sublist(
              index * 10,
              (index + 1) * 30 > datas.length
                  ? datas.length
                  : (index + 1) * 30));
    },
    itemCount: page,
  );
}

/*柱状图*/
Widget BarView(List<MyStatsModel> datas) {
  if(datas.length == 0){
    return NoDataView();
  }
  int page = 1;
  if (datas.length > 10) {
    page = 2;
  }
  return PageView.builder(
    itemBuilder: (context, index) {
      return MyStatsBarChatView(
          datas: datas.sublist(index * 10,
              page > 1 ? (index == 0 ? 10 : datas.length) : datas.length));
    },
    itemCount: page,
  );
}
