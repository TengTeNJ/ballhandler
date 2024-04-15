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
  late TooltipBehavior _tooltipBehavior;
  bool _disposed = false;
  void _callback(Duration duration) {
    if(!_disposed){
      setState(() {});
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      // shouldAlwaysShow: true,
      canShowMarker: false,
      enable: true,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        MyStatsModel model = data as MyStatsModel;
        selectItem(model);
        model.selected = true;
        return MyStatsTipView(dataModel: model);
      },
    );
  }

  /*选中柱形图*/
  selectItem(MyStatsModel model) {
    widget.datas.forEach((MyStatsModel number) {
      number.selected = false;
    });
    model.selected = true;
    // 使用 SchedulerBinding.instance.addPostFrameCallback 来延迟调用 setState，以确保在构建完成后再更新状态
    WidgetsBinding.instance.addPersistentFrameCallback(_callback);
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        // 设置绘图区域的边框宽度为0，隐藏边框
        plotAreaBorderColor: Colors.transparent,
        // 设置绘图区域的边框颜色为透明色
        primaryYAxis: NumericAxis(
          // maximum: 10,
          labelAlignment: LabelAlignment.center,
          interval: 0.2,
          axisLine: AxisLine(width: 1, color: Colors.transparent),
          // 设置 X 轴轴线颜色和宽度
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
          interval: 1,
          axisLine:
              AxisLine(width: 1, color: Color.fromRGBO(112, 112, 112, 1.0)),
          // 设置 X 轴轴线颜色和宽度
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          // 调整标签位置，使得第一个数据和 Y 轴有间隔
          majorGridLines:
              MajorGridLines(color: Colors.transparent, dashArray: [5, 5]),
          majorTickLines: MajorTickLines(width: 0),
          // minimum: 0, // 设置Y轴的最小值
          // maximum: 10, // 设置Y轴的最大值
        ),
        tooltipBehavior: _tooltipBehavior,
        series: <CartesianSeries<MyStatsModel, num>>[
          // Renders column chart
          ColumnSeries<MyStatsModel, num>(
              selectionBehavior: SelectionBehavior(
                  // enable: true, // 这个设置为true,会在选中时，其他的置灰
                  // toggleSelection: false,
                  //  overlayMode: ChartSelectionOverlayMode.top, // 设置选中视图显示在柱状图上面
                  ),
              borderRadius: BorderRadius.circular(5),
              // 设置柱状图的圆角
              dataSource: widget.datas,
              width: 0.3,
              // 设置柱状图的宽度，值为 0.0 到 1.0 之间，表示相对于间距的比例
              spacing: 0.4,
              //
              xValueMapper: (MyStatsModel data, _) =>
                  int.parse(data.indexString),
              yValueMapper: (MyStatsModel data, _) => data.speed,
              pointColorMapper: (MyStatsModel data, _) {
                if (data.selected == true) {
                  print('-----------------');
                  return hexStringToColor('#F8850B');
                } else {
                  print('--------++++++++---------');
                  return hexStringToColor('#CC8E4D');
                }
              })
        ]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _disposed = true;
    super.dispose();
  }
}
