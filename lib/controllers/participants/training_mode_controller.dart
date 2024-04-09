import 'package:code/constants/constants.dart';
import 'package:code/route/route.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/views/participants/training_mode_list_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class TrainingModeController extends StatefulWidget {
  const TrainingModeController({super.key});

  @override
  State<TrainingModeController> createState() => _TrainingModeControllerState();
}

class _TrainingModeControllerState extends State<TrainingModeController> {
  // List View
  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      child: TrainingModeListView(scanBleList: () async{
       NavigatorUtil.push(Routes.recordselect);
       // List<CameraDescription> cameras = await availableCameras();
       //  NavigatorUtil.push('videoCheck',arguments: cameras[0]);
      },),
    );
  }

  void _listener() {
    print('蓝牙连接的设备的数量变化');
    setState(() {
      print('BluetoothManager().conectedDeviceCount=${BluetoothManager().conectedDeviceCount}');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 连接的设备的数量
    BluetoothManager().conectedDeviceCount.addListener(_listener);
  }
  @override
  Widget build(BuildContext context) {
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
              margin: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Constants.mediumWhiteTextWidget('Training Mode', 30),
                  GestureDetector(
                    onTap: () {
                      TTDialog.bleListDialog(context);
                      print('蓝牙连接');
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Image(
                            image:  BluetoothManager().conectedDeviceCount.value>0 ? AssetImage('images/ble/ble_done.png') :AssetImage('images/ble/ble_not.png'),
                            width: 27,
                            height: 27,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Constants.regularWhiteTextWidget( BluetoothManager().conectedDeviceCount.value.toString(), 16),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  // 间隙高度
                  itemCount: 3,
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
