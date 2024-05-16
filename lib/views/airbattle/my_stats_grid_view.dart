import 'dart:convert';

import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../utils/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MyStatsGridView extends StatefulWidget {
  int? index = 0;
  String? value = '-';
  String comparevalue;
  bool riseUp = true;
  int selectType;

  MyStatsGridView(
      {this.index,
      this.value,
      required this.comparevalue,
      required this.riseUp,
      required this.selectType});

  @override
  State<MyStatsGridView> createState() => _MyStatsGridViewState();
}

class _MyStatsGridViewState extends State<MyStatsGridView> {
  final List<String> _imagePaths = [
    'images/profile/time.png',
    'images/profile/score.png',
    'images/profile/training.png',
    'images/profile/home.png'
  ];
  final List<String> _titles = [
    'Best React Time',
    'Total Score',
    'Time on Trainings',
    'Trainings'
  ];

  final List<String> _desTitles = ['Sec', 'Pts', 'Min', ''];
  List<String> _vsTitles = [
    'VS.Last 7 days',
    'VS.Last 30 days',
    'VS.Last 90 days',
    'Custom'
  ];
  String _compareTextColor = '#5BCC6A'; // 默认数据对比上升

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 正常来说initState方法走一次，但是如果其父试图刷新试图时改变了传过来的属性，正常不会走initState方法，但是build函数会刷新，所以不要在initState方法里面写根据外部的属性值重新给内部_属性赋值来刷新页面的逻辑，可以监听didUpdateWidget，刷新数据时监测某个外部属性，然后改变内部属性，调用setState刷新页面
  }

  void didUpdateWidget(MyStatsGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 监听外部值的变化，并更新内部值
    setState(() {
      _compareTextColor = '#5BCC6A';
      if (!widget.riseUp) {
        // 数据对比下降
        _compareTextColor = '#E33E3E';
      }
      if (widget.comparevalue == '-') {
        // 参照点或者当前时间点无数据
        _compareTextColor = '#B1B1B1';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 848),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Container(
          height: 146,
          width: (Constants.screenWidth(context) - 8 - 32) / 2.0,
          decoration: BoxDecoration(
              color: hexStringToColor('#3E3E55'),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(baseMargin(context, 10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Constants.regularGreyTextWidget(
                        _titles[widget.index ?? 0], kFontSize(context, 12)),
                    Image(
                      image: AssetImage(_imagePaths[widget.index ?? 0]),
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: baseMargin(context, 16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12, right: 10),
                      child: SingleChildScrollView(child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.value ?? '-',
                            style: TextStyle(
                                fontSize: kFontSize(context, 40),
                                color: Colors.white,
                                height: 0.8,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _desTitles[widget.index ?? 0],
                            style: TextStyle(
                                fontSize: kFontSize(context, 10),
                                color: Colors.white,
                                height: 0.8),
                          )
                        ],
                      ),scrollDirection: Axis.horizontal,),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    widget.selectType == 3
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                _vsTitles[widget.selectType],
                                style: TextStyle(
                                    color: hexStringToColor('#B1B1B1'),
                                    fontFamily: 'SanFranciscoDisplay',
                                    fontSize: kFontSize(context, 12)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Constants.customTextWidget(
                                      widget.comparevalue,
                                      kFontSize(context, 12),
                                      _compareTextColor),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  RaiseIcon()
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget RaiseIcon() {
    if (widget.comparevalue == '-') {
      return Container();
    }
    return widget.riseUp
        ? Icon(
            size: 12,
            Icons.arrow_upward,
            color: hexStringToColor('#5BCC6A'),
          )
        : Icon(
            size: 12,
            Icons.arrow_downward,
            color: hexStringToColor('#E33E3E'),
          );
  }
}
