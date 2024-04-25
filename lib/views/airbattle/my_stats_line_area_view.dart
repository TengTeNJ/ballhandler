import 'package:code/constants/constants.dart';
import 'package:code/models/mystats/my_stats_model.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/airbattle/my_stats_tip_view.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class MyStatsLineAreaView extends StatefulWidget {
  List<MyStatsModel> datas = [];
  MyStatsLineAreaView({required this.datas});
  @override
  State<MyStatsLineAreaView> createState() => _MyStatsLineAreaViewState();
}

class _MyStatsLineAreaViewState extends State<MyStatsLineAreaView> {
  TooltipBehavior _tooltipBehavior = TooltipBehavior(
    enable: true,
    builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
        int seriesIndex) {
      // 在这里返回您自定义的提示框内容，可以是一个Widget
      // data.setting = MarkerSettings(
      //   isVisible: true,
      //   borderColor: Colors.white,
      //   shape: DataMarkerType.circle,
      //   // 设置数据点为圆形
      //   color: Colors.orange,
      //   // 设置数据点颜色
      //   height: 8,
      //   // 设置数据点高度
      //   width: 8, // 设置数据点宽度
      // );
      // series.forEach((SalesData number) {
      //   number.selected = false;
      // });
      // data.selected = true;
      MyStatsModel model = data as MyStatsModel;
      return MyStatsTipView(dataModel: model);
    },
  );

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      // legend: Legend(isVisible: true),
      selectionType: SelectionType.point,
      plotAreaBorderColor: Colors.transparent,
      // 控制和Y交叉方向的直线的样式
      primaryYAxis: NumericAxis(
        maximum: 52,
          axisLine: AxisLine(width: 2, color: Colors.transparent), // 设置 X 轴轴线颜色和宽度
          labelPosition: ChartDataLabelPosition.outside,
          plotOffset: 0,
          interval: 5,
          majorTickLines: MajorTickLines(color: Colors.yellow, size: 0),
          // 超出坐标系部分的线条设置
          majorGridLines: MajorGridLines(
              color: Color.fromRGBO(112, 112, 112, 1.0),
              dashArray: [5, 5]) // 设置Y轴网格竖线为虚线,
      ),
      backgroundColor: Color.fromRGBO(41, 41, 54, 1.0),
      onSelectionChanged: (SelectionArgs args) {
        //selectedIndexes.clear(); // 清空之前选中的索引
        print('------------ ${args.pointIndex}');
      },
      primaryXAxis: CategoryAxis(
        axisLine: AxisLine(width: 1, color: Color.fromRGBO(112, 112, 112, 1.0)), // 设置 X 轴轴线颜色和宽度
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
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(251, 186, 0, 0.4),
                hexStringToOpacityColor('#9A7719', 0.4)
              ],
            ),
            // color: Colors.green,
            borderColor: Constants.baseStyleColor, // 设置边界线颜色
            borderWidth: 2, // 设置边界线宽度
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
            yValueMapper: (MyStatsModel data, _) => data.speed > 50 ? 50 : data.speed),
        // AreaSeries(
        //   color: Colors.red,
        //     borderColor: Colors.blue, // 设置边界线颜色
        //     borderWidth: 2, // 设置边界线宽度
        //      markerSettings: MarkerSettings(
        //       isVisible: true,
        //       borderColor: Colors.white,
        //       shape: DataMarkerType.circle,
        //       // 设置数据点为圆形
        //       color: Colors.white,
        //       // 设置数据点颜色
        //       height: 8,
        //       // 设置数据点高度
        //       width: 8, // 设置数据点宽度
        //     ),
        //     dataSource:series,
        //     pointColorMapper: (SalesData sales, _) => sales.color,
        //     xValueMapper: (SalesData sales, _) => sales.year,
        //     yValueMapper: (SalesData sales, _) => sales.sales - 0.01 ),

      ],
    );
  }
}
