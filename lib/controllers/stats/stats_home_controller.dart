import 'package:code/services/http/participants.dart';
import 'package:code/views/stats/line_thumbnail_view.dart';
import 'package:code/views/stats/milestone_thumbnail_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../constants/constants.dart';
import '../../models/mystats/my_stats_model.dart';
import '../../services/http/rank.dart';
import '../../utils/color.dart';
import '../../utils/dialog.dart';
import '../../utils/global.dart';
import '../../utils/string_util.dart';
import '../../utils/system_device.dart';
import '../../views/airbattle/my_stats_grid_list_view.dart';
import '../../widgets/navigation/CustomAppBar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class StatsHomeController extends StatefulWidget {
  const StatsHomeController({super.key});

  @override
  State<StatsHomeController> createState() => _StatsHomeControllerState();
}

class _StatsHomeControllerState extends State<StatsHomeController> {
  List<MyStatsModel> datas = [];
  List<MyStatsModel> barViewDatas = [];
  AnalyzeDataModel _analyzeDataModelmodel = AnalyzeDataModel();
  late String selectedValue;
  late int currentIndex;
  late GameScene initGameScene;// 进页面时记录的
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
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    initGameScene = gameUtil.gameScene;

    final result = gameUtil.sceneList.firstWhere((item) => item.dictKey == (gameUtil.gameScene.index + 1).toString());
    selectedValue = result.dictValue;
    currentIndex = int.parse(result.dictKey);
    initData();
  }

  @override
  Widget build(BuildContext context) {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    print('gameUtil.sceneList${gameUtil.sceneList}');
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(),
      body: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
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
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                        isExpanded: true,
                        value: selectedValue,
                        buttonStyleData: ButtonStyleData(
                          height: 24,
                          width: 200,
                          padding: const EdgeInsets.only(left: 12, right: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: hexStringToColor('#707070'),
                            ),
                            color: hexStringToColor('#292936'),
                          ),
                          elevation: 2,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: hexStringToColor('#292936'),
                          ),
                          offset: const Offset(0, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all(6),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value!;
                            final result = gameUtil.sceneList.firstWhere((item) => item.dictValue == value);
                            print('value=${value}');
                            print('${result.dictKey}-${result.dictValue}');
                            gameUtil.gameScene = GameScene.values[int.parse(result.dictKey) - 1];
                            initData();
                            changeTimeArea(
                                _end.isNotEmpty ? _end : null, _start.isNotEmpty ? _start : null, (_timeIndex + 1).toString());
                          });
                        },
                        items: gameUtil.sceneList.map((SceneModel model) {
                          return DropdownMenuItem(
                              value: model.dictValue,
                              child: Constants.regularWhiteTextWidget(
                                  model.dictValue, 12));
                        }).toList()),
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
              const SizedBox(
                height: 8,
              ),
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

  @override
  void dispose() {
    // TODO: implement dispose
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    gameUtil.gameScene =  initGameScene;
    print('gameUtil.gameScene=${gameUtil.gameScene}');
    super.dispose();
  }
}
