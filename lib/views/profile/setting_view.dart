import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/device_debug_data.dart';
import 'package:code/views/dialog/drop_down_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/blue_tooth_manager.dart';
import '../../utils/global.dart';

class SettingView extends StatefulWidget {
  List<String> datas;
  List<String> detailTitles;
  List<bool> showArrows;
  List<bool>? showSwitchs;
  List<bool>? showDropDown;

  String title;
  Function? selectItem;

  SettingView(
      {required this.title,
      required this.datas,
      this.selectItem,
      this.showSwitchs,
      this.showDropDown,
      required this.detailTitles,
      required this.showArrows});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    List<bool> _switchs = [
      BluetoothManager().debugModel.debugSwitch,
      BluetoothManager().debugModel.btSwitch,
      BluetoothManager().debugModel.preSwitch
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Constants.mediumWhiteTextWidget(widget.title, 20),
        SizedBox(
          height: 8,
        ),
        Column(
          children: List.generate(widget.datas.length, (index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // 点击cell
                if (widget.showArrows[index]) {
                  if (widget.selectItem != null) {
                    widget.selectItem!(index);
                  }
                }
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Constants.regularGreyTextWidget(widget.datas[index], 18),
                      Row(
                        children: [
                               Constants.regularGreyTextWidget(
                                  widget.detailTitles[index], 18),
                          SizedBox(
                            width: 12,
                          ),
                          widget.showSwitchs != null &&
                                  widget.showSwitchs![index]
                              ? Switch(
                                  value:
                                  _switchs[index-3],
                                  onChanged: (value) {
                                    List<List<int>> _datas = [setDebug(value),setBT(value),setPre(value)];
                                    // 设置debug
                                    GameUtil gameUtil =
                                        GetIt.instance<GameUtil>();
                                    print('value = ${value}');
                                    BluetoothManager().writerDataToDevice(
                                        gameUtil.selectedDeviceModel,
                                        _datas[index-3]);
                                  })
                              : (widget.showArrows[index]
                                  ? Image(
                                      image: AssetImage(
                                          'images/airbattle/next_white.png'),
                                      width: 12,
                                      height: 12,
                                    )
                                  : Container())
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    color: hexStringToColor('#707070'),
                    height: 0.5,
                  ),
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}
