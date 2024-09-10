import 'package:code/constants/constants.dart';
import 'package:code/controllers/participants/p1_controller.dart';
import 'package:code/controllers/participants/p2_controller.dart';
import 'package:code/controllers/participants/p3_controller.dart';
import 'package:code/controllers/participants/test_game_controller.dart';
import 'package:code/models/ble/ble_model.dart';
import 'package:code/route/route.dart';
import 'package:code/services/http/participants.dart';
import 'package:code/utils/audio_player_util.dart';
import 'package:code/utils/ble_ultimate_data.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/views/airbattle/my_award_view.dart';
import 'package:code/views/base/five_statu_view.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:code/views/base/statu_view.dart';
import 'package:code/views/participants/training_mode_list_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../utils/ble_util.dart';
import '../../utils/event_track.dart';
import '../../utils/global.dart';
import '../../utils/system_device.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import '../../utils/toast.dart';

class TrainingModeController extends StatefulWidget {
  const TrainingModeController({super.key});

  @override
  State<TrainingModeController> createState() => _TrainingModeControllerState();
}

class _TrainingModeControllerState extends State<TrainingModeController> {
  List<GameModel> _datas = [];
  String title = 'Stickhandling';

  // List View
  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      child: TrainingModeListView(
        model: _datas[index],
        scanBleList: () async {
          GameUtil gameUtil = GetIt.instance<GameUtil>();
          gameUtil.selectRecord = false;
          if (BluetoothManager().conectedDeviceCount.value == 0) {
            if (await SystemUtil.isIPad()) {
              TTDialog.ipadbleListDialog(context);
            } else {
              TTDialog.bleListDialog(context);
            }
            BleUtil.begainScan(context);
          } else {
            List<String> bleNames = [
              kFiveBallHandler_Name,
              k270_Name,
              kThreeBallHandler_Name
            ];
            // 确认已连接的设备中是否有和当前模式匹配的,有的话则取第一个
            List<BLEModel> devices = BluetoothManager()
                .hasConnectedDeviceList
                .where((element) => element.deviceName
                    .contains(bleNames[gameUtil.gameScene.index]))
                .toList();
            if (devices.length == 0) {
              // 没有和当前模式相匹配的设备
              if (await SystemUtil.isIPad()) {
                TTDialog.ipadbleListDialog(context);
              } else {
                TTDialog.bleListDialog(context);
              }
              return;
            }
            gameUtil.selectedDeviceModel = devices.first;
            gameUtil.modelId = index + 1;
            if (gameUtil.gameScene == GameScene.five) {
              NavigatorUtil.push(Routes.recordselect);
            } else if (gameUtil.gameScene == GameScene.erqiling) {
              // 设置270的游戏模式
              BluetoothManager().writerDataToDevice(
                  gameUtil.selectedDeviceModel, selectMode(index));
              // 主机状态
              if (BluetoothManager().gameData.masterStatu != 2) {
                TTToast.showErrorInfo(
                    'The device is not ready yet, please check the device');
                // 查询主机状态
                BluetoothManager().writerDataToDevice(
                    gameUtil.selectedDeviceModel, queryMasterSystemStatu());
                return;
              }
              if (index == 2) {
                // 270的P3自由控制模式
                BluetoothManager().writerDataToDevice(
                    gameUtil.selectedDeviceModel, p3ScreenShow());
                BluetoothManager().writerDataToDevice(
                    gameUtil.selectedDeviceModel, scoreShow(0));
              }
              const List<Widget> _controllers = [
                P1Controller(),
                P2Controller(),
                P3Controller(),
              ];
              // 清空上次选择的组合
              // gameUtil.selectdP3Indexs.clear();
              NavigatorUtil.present(_controllers[index]);
            }
          }
        },
      ),
    );
  }

  void _listener() {
    print('蓝牙连接的设备的数量变化');
    setState(() {
      print(
          'BluetoothManager().conectedDeviceCount=${BluetoothManager().conectedDeviceCount}');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 连接的设备的数量
    BluetoothManager().conectedDeviceCount.addListener(_listener);
    queryModeListData();
    // 隐藏状态栏和底部导航栏
    // FlutterStatusbarcolor.setStatusBarColor(Colors.green);\
    getTitle();
  }

  getTitle() {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    String _title = kTrainingMode_ReleaseNames[gameUtil.gameScene.index];
    setState(() {
      title = _title;
    });
  }

  queryModeListData() async {
    final _response = await Participants.queryModelListData();
    if (_response.success && _response.data != null) {
      _datas.addAll(_response.data!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(
        showBack: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Constants.boldWhiteTextWidget(title, 30, height: 0.8),
                  GestureDetector(
                    onTap: () async {
                      if (await SystemUtil.isIPad()) {
                        TTDialog.ipadbleListDialog(context);
                      } else {
                        TTDialog.bleListDialog(context);
                      }
                      BleUtil.begainScan(context);
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Image(
                            image: AssetImage('images/ble/ble_link.png'),
                            width: 27,
                            height: 27,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: gameUtil.gameScene == GameScene.erqiling
                  ? DeviceStatuView()
                  : FiveStatuView(),
              margin: EdgeInsets.only(left: 16),
            ),
            SizedBox(
              height: 32,
            ),
            Expanded(
              child: _datas.length == 0
                  ? NoDataView()
                  : ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 20),
                      // 间隙高度
                      itemCount: _datas.length,
                      itemBuilder: _itemBuilder),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    BluetoothManager().conectedDeviceCount.removeListener(_listener);
    super.dispose();
  }
}
