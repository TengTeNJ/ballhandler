import 'dart:async';

import 'package:code/constants/constants.dart';
import 'package:code/models/ble/ble_model.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/notification_bloc.dart';

class BLEListView extends StatefulWidget {
  const BLEListView({super.key});

  @override
  State<BLEListView> createState() => _BLEListViewState();
}

class _BLEListViewState extends State<BLEListView> {
  late StreamSubscription subscription;

  final List<String> _imageNames = [
    'images/base/five.png',
    'images/base/270.png',
    'images/base/three.png'
  ];
  final List<String> _titles = [
    'Digital Stickhandling Trainer',
    'Ultimater Dangler',
    'Razor Dangler 2.0'
  ];

  void listener() {
    print('搜索到蓝牙设备变化');
    if (mounted) {
      setState(() {
        print('BluetoothManager().deviceList=${BluetoothManager().deviceList}');
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('----------initState-----------');
    BluetoothManager().deviceListLength.addListener(listener);
    subscription = EventBus().stream.listen((event) async {
      if (event == kInitiativeDisconnect) {
        // 主动断开连接
        if(mounted){
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // /color: Colors.orange,
      margin: EdgeInsets.only(left: 16, right: 16),
      width: Constants.screenWidth(context) - 32,
      height: Constants.screenHeight(context) * 0.45 - 99 - 44,
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return index != (BluetoothManager().showDeviceList.length)
                ? InkWell(
                    child: Container(
                      height: 60,
                      width: Constants.screenWidth(context),
                      child: Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BluetoothManager()
                                      .showDeviceList[index]
                                      .hasConected ==
                                  true
                              ? Image(
                                  image: AssetImage(
                                      'images/participants/point.png'),
                                  width: 14,
                                  height: 14,
                                )
                              : Container(),
                          SizedBox(
                            width: 8,
                          ),
                          BluetoothManager().showDeviceList[index].modelStatu !=
                                  BLEModelStatu.virtual
                              ? Constants.mediumWhiteTextWidget(
                                  BluetoothManager()
                                      .showDeviceList[index]
                                      .deviceName,
                                  16,
                                )
                              : Constants.customTextWidget(
                                  BluetoothManager()
                                      .showDeviceList[index]
                                      .deviceName,
                                  16,
                                  '#65657D'),
                        ],
                      )),
                    ),
                    onTap: () {
                      print('连接蓝牙设备');
                      if (BluetoothManager()
                                  .showDeviceList[index]
                                  .hasConected ==
                              true ||
                          BluetoothManager().showDeviceList[index].modelStatu ==
                              BLEModelStatu.virtual) {
                        // 虚拟设备和已连接设备不需要连接
                        print('虚拟设备和已连接设备不需要连接');
                        if (BluetoothManager()
                                .showDeviceList[index]
                                .hasConected ==
                            true) {
                          print('已连接设备断开连接');
                          BluetoothManager().disconecteDevice(
                              BluetoothManager().showDeviceList[index]);
                          //BluetoothManager().showDeviceList[index].bleStream?.cancel();
                        }
                      } else {
                        BluetoothManager().conectToDevice(
                            BluetoothManager().showDeviceList[index]);
                      }
                    },
                  )
                : SizedBox();
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
                thickness: 2,
                color: Color.fromRGBO(86, 86, 116, 1.0),
              ),
          itemCount: BluetoothManager().showDeviceList.length + 1),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // 移除监听
    BluetoothManager().deviceListLength.removeListener(listener);
    BluetoothManager().stopScan();
    super.dispose();
  }
}
