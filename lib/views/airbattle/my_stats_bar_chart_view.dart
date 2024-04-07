import 'package:code/models/mystats/my_stats_model.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/airbattle/my_stats_tip_view.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class MyStatsBarChatView extends StatefulWidget {
  List<MyStatsModel> datas = [];
  MyStatsBarChatView({required this.datas});
  @override
  State<MyStatsBarChatView> createState() => _MyStatsBarChatViewState();
}

class _MyStatsBarChatViewState extends State<MyStatsBarChatView> {
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
        plotAreaBorderWidth: 0,
        // 设置绘图区域的边框宽度为0，隐藏边框
        plotAreaBorderColor: Colors.transparent,
        // 设置绘图区域的边框颜色为透明色
        primaryYAxis: NumericAxis(
          labelAlignment: LabelAlignment.center,
          // interval: 1,range
          axisLine: AxisLine(width: 1, color: Colors.transparent), // 设置 X 轴轴线颜色和宽度
          plotOffset: 0,
          labelPosition: ChartDataLabelPosition.outside,
          // labelStyle: TextStyle(fontSize: 12, color: Colors.black), // 设置标签样式
          majorGridLines: MajorGridLines(dashArray: [5, 5]),
          majorTickLines: MajorTickLines(width: 0),

          //opposedPosition: true, // 将 Y 轴放置在图表的右侧

          // minimum: 0, // 设置 Y 轴的最小值为0
          // maximum: 50, // 设置 Y 轴的最大值
          // interval: 10, // 设置 Y 轴的间隔
          //  edgeLabelPlacement: EdgeLabelPlacement.shift, // 调整标签位置，使得第一个数据和 Y 轴有间隔

        ),
        primaryXAxis: CategoryAxis(
          plotOffset: 1,
          interval: 2,
          axisLine: AxisLine(width: 1, color: Color.fromRGBO(112, 112, 112, 1.0)), // 设置 X 轴轴线颜色和宽度
          edgeLabelPlacement: EdgeLabelPlacement.shift, // 调整标签位置，使得第一个数据和 Y 轴有间隔
          majorGridLines: MajorGridLines(color: Colors.transparent, dashArray: [5, 5]),
          majorTickLines: MajorTickLines(width: 0),
          // minimum: 0, // 设置Y轴的最小值
          // maximum: 10, // 设置Y轴的最大值
        ),
        tooltipBehavior: _tooltipBehavior,
        series: <CartesianSeries<MyStatsModel, num>>[
          // Renders column chart
          ColumnSeries<MyStatsModel, num>(

            selectionBehavior: SelectionBehavior(
              enable: true,
              toggleSelection: false,
              //  overlayMode: ChartSelectionOverlayMode.top, // 设置选中视图显示在柱状图上面
            ),
            borderRadius: BorderRadius.circular(5), // 设置柱状图的圆角
            dataSource: widget.datas,
            width: 0.8, // 设置柱状图的宽度，值为 0.0 到 1.0 之间，表示相对于间距的比例
            spacing: 0.4, //
            // gradient: LinearGradient(
            //   colors: <Color>[Colors.blue, Colors.green], // 设置柱子的渐变色填充
            // ),
            //  gradient: null, // 将柱子的渐变色填充设置为null，显示为单一颜色
            xValueMapper: (MyStatsModel data, _) => data.speed,
            yValueMapper: (MyStatsModel data, _) => int.parse(data.indexString),
            pointColorMapper: (MyStatsModel data, _) => hexStringToColor('#CC8E4D'),
            //spacing: 0.8,
            //dashArray: [50,5,5,5],
            // color: Colors.red,
            // width: 0.5,
            // enableTooltip: true,
            isTrackVisible: false,
            // 如果设置为true ,那么如果该组最大高度为100，而其中一个数据为50，那么这个数据对应的柱状图的实际高度仍然为100处，只是，50-100处和0-50处的颜色不同
            //trackColor: Colors.blue,

          )
        ]);
  }
}
