import 'dart:async';
import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/utils/ble_ultimate_data.dart';
import 'package:code/utils/device_debug_data.dart';
import 'package:code/utils/toast.dart';
import 'package:code/views/profile/debug_setting_view.dart';
import 'package:code/views/profile/setting_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../utils/ble_data_service.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/color.dart';
import '../../utils/dialog.dart';
import '../../utils/global.dart';
import 'package:drop_down_list/drop_down_list.dart';

class DeviceDebugController extends StatefulWidget {
  const DeviceDebugController({super.key});

  @override
  State<DeviceDebugController> createState() => _DeviceDebugControllerState();
}

class _DeviceDebugControllerState extends State<DeviceDebugController> {
  late StreamSubscription subscription;
  late Timer timer;
  List<SelectedListItem> channelDatas = [];
  List<SelectedListItem> levelDatas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 30), (timer) {
      queryParameter();
    });
    queryParameter();
    BluetoothManager().dataChange = (BLEDataType type) async {
      if (type == BLEDataType.queryDeviceParameter) {
        setState(() {});
      } else if (type == BLEDataType.setDeviceParameter) {
        // 重新刷新页面
        queryParameter();
      }
    };
    initData();
  }

  initData() {
    for (int i = 0; i < kChannelArray.length; i++) {
      SelectedListItem item = SelectedListItem(name: '通道${kChannelArray[i]}');
      item.value = kChannelArray[i].toString();
      if (i == 2) {
        item.isSelected = true;
      }
      channelDatas.add(item);
    }

    List<String> levelArray = ['最高', '高', '中', '低','最低(测试)','极限(测试)'];
    for (int i = 0; i < levelArray.length; i++) {
      SelectedListItem item = SelectedListItem(name:levelArray [i]);
      item.value = i.toString();
      levelDatas.add(item);
    }
  }

  queryParameter() {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    // 查询通道
    BluetoothManager()
        .writerDataToDevice(gameUtil.selectedDeviceModel, queryChannel());
    // 查询干扰级别
    BluetoothManager().writerDataToDevice(
        gameUtil.selectedDeviceModel, queryReferenceLevel());
    // 查询自动关机时间
    BluetoothManager()
        .writerDataToDevice(gameUtil.selectedDeviceModel, queryOffTime());
    // 查询debug开关
    BluetoothManager()
        .writerDataToDevice(gameUtil.selectedDeviceModel, queryDebugSwitch());
    // 查询BT开关
    BluetoothManager()
        .writerDataToDevice(gameUtil.selectedDeviceModel, querybBTSwitch());
    // 查询321预备开关
    BluetoothManager()
        .writerDataToDevice(gameUtil.selectedDeviceModel, querypRESwitch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: true,
      ),
      backgroundColor: Constants.darkThemeColor,
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Constants.boldWhiteTextWidget('Settings', 30),
              SizedBox(
                height: 32,
              ),
              Consumer<UserModel>(builder: (context, userModel, child) {
                return SettingView(
                  showArrows: [true, true, true, true],
                  showSwitchs: [false, false, false, true,true,true],
                  showDropDown: [true, false, false, false,false,false],
                  title: '状态',
                  datas: ['通信信道', '干扰容错级别', '自动关机时间', 'DEBUG','BT自动断连','321预备'],
                  detailTitles: [
                    '通道' + BluetoothManager().debugModel.channel.toString(),
                    ['最高', '高', '中', '低','最低(测试)','极限(测试)'][BluetoothManager().debugModel.interferenceLevel],
                    BluetoothManager().debugModel.autoOffRemainString,
                    '',
                    '',
                    ''
                  ],
                  selectItem: (index) {
                    if (index == 0) {
                      // 修改信道
                      DropDownState(
                        heightOfBottomSheet: 500,
                        DropDown(
                          // isSearchVisible: false,
                          bottomSheetTitle:
                              Constants.boldBlackTextWidget('通信通道', 20),
                          searchHintText: '搜索',
                          data: channelDatas,
                          onSelected: (List<dynamic> selectedList) {
                            SelectedListItem item = selectedList.first;
                            print('selectedList = ${selectedList}');
                            GameUtil gameUtil = GetIt.instance<GameUtil>();
                            int index = kChannelArray
                                .indexOf(int.parse(item.value ?? '0'));
                            BluetoothManager().writerDataToDevice(
                                gameUtil.selectedDeviceModel,
                                setChannel(index));
                          },
                          enableMultipleSelection: false,
                        ),
                      ).showModal(context);
                      // TTDialog.channelDialog(context, (value) async {
                      //   if (ISEmpty(value)) {
                      //     return;
                      //   }
                      //   if (!kChannelArray.contains(int.parse(value))) {
                      //     TTToast.showErrorInfo(
                      //         '请输入合法的级别数据,0,1,3, 19,21,23,25,27, 47,49,51,52, 71,73,75,77,79');
                      //     return;
                      //   }
                      //   GameUtil gameUtil = GetIt.instance<GameUtil>();
                      //   int index = kChannelArray.indexOf(int.parse(value));
                      //   BluetoothManager().writerDataToDevice(
                      //       gameUtil.selectedDeviceModel, setChannel(index));
                      // });
                    } else if (index == 1) {
                      DropDownState(
                        heightOfBottomSheet: 500,
                        DropDown(
                          // isSearchVisible: false,
                          bottomSheetTitle:
                          Constants.boldBlackTextWidget('干扰容错级别', 20),
                          searchHintText: '搜索',
                          data: levelDatas,
                          onSelected: (List<dynamic> selectedList) {
                            SelectedListItem item = selectedList.first;
                            print('selectedList = ${selectedList}');
                            GameUtil gameUtil = GetIt.instance<GameUtil>();
                            int index = levelDatas
                                .indexOf(item);
                            BluetoothManager().writerDataToDevice(
                                gameUtil.selectedDeviceModel,
                                setReferenceLevell(index));
                          },
                          enableMultipleSelection: false,
                        ),
                      ).showModal(context);
                      // 修改 干扰容错级别
                      // TTDialog.setInterferenceLevelDialog(context,
                      //     (value) async {
                      //   if (ISEmpty(value)) {
                      //     return;
                      //   }
                      //   if (!["0", "1", "2", "3"].contains(value)) {
                      //     TTToast.showErrorInfo('请输入合法的级别数据');
                      //     return;
                      //   }
                      //   GameUtil gameUtil = GetIt.instance<GameUtil>();
                      //   BluetoothManager().writerDataToDevice(
                      //       gameUtil.selectedDeviceModel,
                      //       setReferenceLevell(int.parse(value)));
                      // });
                    } else if (index == 2) {
                      // 修改 自动关机时间
                      TTDialog.setRemainTimeDialog(context, (value) async {
                        if (ISEmpty(value)) {
                          return;
                        }
                        GameUtil gameUtil = GetIt.instance<GameUtil>();
                        BluetoothManager().writerDataToDevice(
                            gameUtil.selectedDeviceModel,
                            setAutoOffTime(int.parse(value)));
                      });
                    }
                  },
                );
              }),
              SizedBox(
                height: 32,
              ),
              SettingView(
                  title: '重置',
                  datas: ['REBOOT', '重置自动关机定时器'],
                  detailTitles: ['', ''],
                  showArrows: [true, true],
                  selectItem: (index) {
                    if (index == 0) {
                      // REBOOT
                      GameUtil gameUtil = GetIt.instance<GameUtil>();
                      BluetoothManager().writerDataToDevice(
                          gameUtil.selectedDeviceModel, reboot());
                    } else if (index == 1) {
                      // 重置自动关机定时器
                      GameUtil gameUtil = GetIt.instance<GameUtil>();
                      BluetoothManager().writerDataToDevice(
                          gameUtil.selectedDeviceModel, resetTimer());
                    }
                  }),
              SizedBox(
                height: 32,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // 关机
                  GameUtil gameUtil = GetIt.instance<GameUtil>();
                  BluetoothManager().writerDataToDevice(
                      gameUtil.selectedDeviceModel, turnoff());
                },
                child: Column(
                  children: [
                    Container(
                      color: hexStringToColor('#707070'),
                      height: 0.5,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Constants.regularGreyTextWidget('关机', 16),
                        Image(
                          image: AssetImage('images/airbattle/next_white.png'),
                          width: 12,
                          height: 12,
                        )
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (timer != null) {
      timer.cancel();
    }
    BluetoothManager().dataChange = null;
    super.dispose();
  }
}
