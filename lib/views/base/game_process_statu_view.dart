import 'package:code/utils/color.dart';
import 'package:code/views/base/ble_view.dart';
import 'package:code/views/base/new_battery_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/global.dart';

class GameProcessStatuView extends StatefulWidget {
  const GameProcessStatuView({super.key});

  @override
  State<GameProcessStatuView> createState() => _GameProcessStatuViewState();
}

class _GameProcessStatuViewState extends State<GameProcessStatuView> {
  @override
  Widget build(BuildContext context) {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 90,
          height: 24,
          child: NewBatteryView(),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: hexStringToOpacityColor('#1C1E21', 0.6)
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Container(
          width: 24,
          height: 24,
          child: BLEView(),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: hexStringToOpacityColor('#1C1E21', 0.6)),
        ),
        SizedBox(
          width: gameUtil.selectRecord ? 12 : 0,
        ),
        gameUtil.selectRecord
            ? Container(
                width: 24,
                height: 24,
                child: Center(
                  child: Image(
                    image: AssetImage('images/ble/red.png'),
                    width: 8,
                    height: 8,
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: hexStringToOpacityColor('#1C1E21', 0.6)),
              )
            : Container()
      ],
    );
  }
}
