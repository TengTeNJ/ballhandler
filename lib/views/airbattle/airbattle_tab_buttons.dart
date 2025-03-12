import 'dart:async';

import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

import '../../utils/notification_bloc.dart';

class AirbattleTabButtons extends StatefulWidget {
  List<String> titles;
  int selectIndex;
  Function? selectTab;

  AirbattleTabButtons(
      {super.key, required this.titles, this.selectTab, this.selectIndex = 0});

  @override
  State<AirbattleTabButtons> createState() => _AirbattleTabButtonsState();
}

class _AirbattleTabButtonsState extends State<AirbattleTabButtons> {
  int _selectIndex = 0;
  late StreamSubscription subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('_AirbattleTabButtonsState');
    setState(() {
      _selectIndex = widget.selectIndex;
    });
    subscription = EventBus().stream.listen((event) {
      if (event is String && event == kAirBattleChangeActivity) {
        setState(() {
          _selectIndex = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      height: 38,
      width: Constants.screenWidth(context) - 32,
      decoration: BoxDecoration(
          color: hexStringToColor('#3E3E55'),
          borderRadius: BorderRadius.circular(26)),
      child: Scrollbar(
        thickness: 5, // 滚动条宽度
        radius: Radius.circular(2),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(widget.titles.length, (index) {
              return Container(
                height: 38,
                padding: EdgeInsets.only(left: 8, right: 8),
                margin: EdgeInsets.only(
                    right: index == (widget.titles.length - 1) ? 0 : 24),
                decoration: BoxDecoration(
                    color: _selectIndex == index
                        ? Constants.baseStyleColor
                        : hexStringToColor('#3E3E55'),
                    borderRadius: BorderRadius.circular(26)),
                child: Center(
                  child: GestureDetector(
                    child: Constants.regularWhiteTextWidget(
                        widget.titles[index], 14,
                        maxLines: 1),
                    onTap: () {
                      setState(() {
                        _selectIndex = index;
                      });
                      if (widget.selectTab != null) {
                        widget.selectTab!(index);
                      }
                    },
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    subscription.cancel();
    super.dispose();
  }
}
