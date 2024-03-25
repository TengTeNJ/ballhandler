import 'package:code/constants/constants.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:flutter/material.dart';

class BLEListView extends StatefulWidget {
  const BLEListView({super.key});

  @override
  State<BLEListView> createState() => _BLEListViewState();
}

class _BLEListViewState extends State<BLEListView> {
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
    print('蓝牙数据变化');
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BluetoothManager().deviceListLength.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      width: Constants.screenWidth(context) - 32,
      height: Constants.screenHeight(context) * 0.42 - 99 - 44,
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return index != (BluetoothManager().deviceList.length)
                ? GestureDetector(child: Container(
              height: 60,
              width: Constants.screenWidth(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(_imageNames[index]),
                    width: 60,
                    height: 30,
                  ),
                  SizedBox(
                    width: 22,
                  ),
                  Constants.mediumWhiteTextWidget(BluetoothManager().deviceList[index].device.name, 14),
                ],
              ),
            ),onTap: (){
                  print('连接蓝牙设备');
                  BluetoothManager().conectToDevice(BluetoothManager().deviceList[index]);
            },)
                : SizedBox();
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
                thickness: 2,
                color: Color.fromRGBO(86, 86, 116, 1.0),
              ),
          itemCount: BluetoothManager().deviceListLength.value + 1),
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
