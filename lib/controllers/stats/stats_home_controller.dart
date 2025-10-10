import 'package:code/views/stats/line_thumbnail_view.dart';
import 'package:code/views/stats/milestone_thumbnail_view.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../models/mystats/my_stats_model.dart';
import '../../services/http/rank.dart';
import '../../utils/color.dart';
import '../../utils/dialog.dart';
import '../../utils/string_util.dart';
import '../../utils/system_device.dart';
import '../../views/airbattle/my_stats_grid_list_view.dart';
import '../../widgets/navigation/CustomAppBar.dart';

class StatsHomeController extends StatefulWidget {
  const StatsHomeController({super.key});

  @override
  State<StatsHomeController> createState() => _StatsHomeControllerState();
}

class _StatsHomeControllerState extends State<StatsHomeController> {
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
  num temp = 24;
  String _start = '';
  String _end = '';
  int _selectType = 1;

/*根据时间范围刷新数据*/
  changeTimeArea(String? startTime, String? endTime, String selectType) async {
    final List<Future<dynamic>> futures = [];
    futures.add(Rank.queryComparetData(startTime, endTime, selectType));
    if (selectType == '1') {
      futures.add(Rank.queryLineViewData(startTime, endTime, isWeek: true));
    } else {
      futures.add(Rank.queryLineViewData(startTime, endTime));
    }
    final _responses = await Future.wait(futures);
    // 对比数据
    final _compareResponse = _responses[0];
    if (_compareResponse.success && _compareResponse.data != null) {
      _analyzeDataModelmodel = _compareResponse.data!;
    }
    // 折线图数据
    final _lineResponse = _responses[1];
    if (_lineResponse.success) {
      _selectType = int.parse(selectType);
      print('_selectType = ${_selectType}');
      if (datas.length > 0) {
        datas.clear();
      }
      if (_lineResponse.data != null && _lineResponse.data!.length > 0) {
        datas.addAll(_lineResponse.data!);
      }
    }
    setState(() {});
  }

  /*获取折线图、柱状图、对比分析数据*/
  initData() async {
    final List<Future<dynamic>> futures = [];
    futures.add(Rank.queryComparetData(null, null, '1'));
    futures.add(Rank.queryLineViewData(null, null, isWeek: true));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(),
      body: Container(
        margin: EdgeInsets.only(left: 16,right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 26,
              ),
              Constants.boldWhiteTextWidget('My Stats', 30),
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image(
                        image: AssetImage('images/ranking/top_rank.png'),
                        width: 14,
                        height: 17,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Constants.regularWhiteTextWidget(
                          ' Ranking #${_analyzeDataModelmodel.rankNumber == '0' ? '-' : _analyzeDataModelmodel.rankNumber}',
                          16),
                    ],
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      // 时间选择弹窗
                      if (await SystemUtil.isIPad()) {
                        TTDialog.iPadTimeSelect(context,
                                (startTime, endTime, index) {
                              _timeIndex = index;
                              _start = startTime;
                              _end = endTime;
                              if (index == 3) {
                                // _titles[_titles.length-1] = "${_start.replaceAll('-', '/')}-${_end.replaceAll('-', '/')}";
                                _titles[_titles.length - 1] =
                                "${StringUtil.serviceStringMyStatuDateString(_start)}-${StringUtil.serviceStringMyStatuDateString(_end)}";
                                setState(() {});
                              }
                              changeTimeArea(
                                  endTime, startTime, (index + 1).toString());
                            },
                            index: _timeIndex,
                            start: _start.length > 0 ? _start : null,
                            end: _end.length > 0 ? _end : null);
                      } else {
                        TTDialog.timeSelect(context,
                                (startTime, endTime, index) {
                              _timeIndex = index;
                              _start = startTime;
                              _end = endTime;
                              if (index == 3) {
                                //_titles[_titles.length-1] = "${_start.replaceAll('-', '/')}-${_end.replaceAll('-', '/')}";
                                _titles[_titles.length - 1] =
                                "${StringUtil.serviceStringMyStatuDateString(_start)}-${StringUtil.serviceStringMyStatuDateString(_end)}";
                                setState(() {});
                              }
                              changeTimeArea(
                                  endTime, startTime, (index + 1).toString());
                            },
                            index: _timeIndex,
                            start: _start.length > 0 ? _start : null,
                            end: _end.length > 0 ? _end : null);
                      }
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
                height: 28,
              ),
              MyStatsGridListView(
                model: _analyzeDataModelmodel,
                selectType: _timeIndex,
              ),
              const SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LineThumbnailView(datas: datas),
                  MilestoneThumbnailView()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
