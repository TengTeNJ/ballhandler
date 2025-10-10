import 'package:code/constants/constants.dart';
import 'package:code/models/mystats/my_stats_model.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/airbattle/my_stats_tip_view.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

List<String> _months = [];

class StatsLineAreaView extends StatefulWidget {
  List<MyStatsModel> datas = [];
  int selectType = 1;

  StatsLineAreaView({required this.datas, required this.selectType});

  @override
  State<StatsLineAreaView> createState() => _StatsLineAreaViewState();
}

class _StatsLineAreaViewState extends State<StatsLineAreaView> {
  TooltipBehavior _tooltipBehavior = TooltipBehavior(
    enable: true,
    builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
        int seriesIndex) {
      MyStatsModel model = data as MyStatsModel;
      return MyStatsTipView(dataModel: model);
    },
  );

  @override
  Widget build(BuildContext context) {
    _months.clear();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Constants.regularGreyTextWidget('AVG.(Sec/pt)', 10),
        SizedBox(
          height: widget.selectType > 10 ? 1 : 10,
        ),
        AspectRatio(aspectRatio: 2,child: SfCartesianChart(
          margin: EdgeInsets.only(left: 0, right: 0, top: 10),
          selectionType: SelectionType.point,
          plotAreaBorderColor: Colors.transparent,
          // 控制和Y交叉方向的直线的样式
          primaryYAxis: NumericAxis(
              axisLabelFormatter: (AxisLabelRenderDetails args) {
                // 格式化为保留一位小数的字符串
                return ChartAxisLabel(args.value.toStringAsFixed(1), null);
              },
              //isInversed:true, // Y轴倒序排列
              edgeLabelPlacement: EdgeLabelPlacement.none,
              // 移除左侧的填充
              labelStyle: TextStyle(
                color: hexStringToColor('#B1B1B1'),
                fontSize: 14,
                fontFamily: 'SanFranciscoDisplay',
                fontWeight: FontWeight.w400,
              ),
              maximum: 5,
              axisLine: AxisLine(width: 2, color: Colors.transparent),
              // 设置 X 轴轴线颜色和宽度
              labelPosition: ChartDataLabelPosition.outside,
              plotOffset: 0,
              interval: 0.5,
              majorTickLines: MajorTickLines(color: Colors.yellow, size: 0),
              // 超出坐标系部分的线条设置
              majorGridLines: MajorGridLines(
                  color: Color.fromRGBO(112, 112, 112, 1.0),
                  dashArray: [5, 5]) // 设置Y轴网格竖线为虚线,
          ),
          // backgroundColor: Color.fromRGBO(41, 41, 54, 1.0),
          onSelectionChanged: (SelectionArgs args) {
            //selectedIndexes.clear(); // 清空之前选中的索引
          },
          primaryXAxis: CategoryAxis(
            axisLabelFormatter: (AxisLabelRenderDetails args) {
              var _week = widget.datas[int.parse(args.text) - 1].simpleWeekDay;
              var _month = widget.datas[int.parse(args.text) - 1].simpleMonth;
              var _day = widget.datas[int.parse(args.text) - 1].simpleDay;
              if (widget.selectType == 1) {
                return ChartAxisLabel(
                    _week,
                    TextStyle(
                      fontSize: 14,
                    ));
              } else {
                if (_months.contains(_month)) {
                  // 使用where方法过滤数组，并计算出现次数
                  //int count = _months.where((element) => element == _month).length;
                  _months.add(_month);
                  return ChartAxisLabel(
                      _day,
                      TextStyle(
                        fontSize: 14,
                      ));
                } else {
                  _months.add(_month);
                  return ChartAxisLabel(
                      _month + '.${_day}',
                      TextStyle(
                        fontSize: 14,
                      ));
                }
                return ChartAxisLabel(
                    _month,
                    TextStyle(
                      fontSize: 14,
                    ));
              }
              // return  ChartAxisLabel('123', TextStyle());
            },
            labelStyle: TextStyle(
              color: hexStringToColor('#B1B1B1'),
              fontSize: 14,
              fontFamily: 'SanFranciscoDisplay',
              fontWeight: FontWeight.w400,
            ),
            axisLine:
            AxisLine(width: 1, color: Color.fromRGBO(112, 112, 112, 1.0)),
            // 设置 X 轴轴线颜色和宽度
            labelPosition: ChartDataLabelPosition.outside,
            //interval: 2,
            majorGridLines:
            MajorGridLines(color: Colors.transparent, dashArray: [5, 5]),
            majorTickLines:
            MajorTickLines(color: Colors.yellow, size: 0), // 超出坐标系部分的线条设置
          ),
          tooltipBehavior: _tooltipBehavior,
          series: <CartesianSeries<MyStatsModel, String>>[
            AreaSeries(
              // borderDrawMode: BorderDrawMode.top, // 设置阴影面积的绘制方式
              // emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.average), // 设置空点模式,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(251, 186, 0, 0.4),
                    hexStringToOpacityColor('#9A7719', 0.4)
                  ],
                ),
                // color: Colors.green,
                borderColor: Constants.baseStyleColor,
                // 设置边界线颜色
                borderWidth: 2,
                // 设置边界线宽度
                // 这里是选中的折线的颜色
                // 这里是选中的折线的颜色
                selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: Colors.green,
                  selectedBorderColor: Colors.green,
                  selectedBorderWidth: 2,
                  toggleSelection: false,
                ),
                markerSettings: MarkerSettings(
                  isVisible: true,
                  borderColor: Colors.white,
                  shape: DataMarkerType.circle,
                  // 设置数据点为圆形
                  color: Colors.white,
                  // 设置数据点颜色
                  height: 6,
                  // 设置数据点高度
                  width: 6, // 设置数据点宽度
                ),
                dataSource: widget.datas,
                pointColorMapper: (MyStatsModel data, _) => Colors.yellow,
                xValueMapper: (MyStatsModel data, _) => data.indexString,
                yValueMapper: (MyStatsModel data, _) =>
                data.speed > 5 ? 5 : data.speed),
          ],
        ),)
      ],
    );
  }
}
