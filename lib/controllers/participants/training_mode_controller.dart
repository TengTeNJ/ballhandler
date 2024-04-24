import 'package:code/constants/constants.dart';
import 'package:code/route/route.dart';
import 'package:code/services/http/participants.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:code/views/participants/training_mode_list_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../utils/global.dart';

class TrainingModeController extends StatefulWidget {
  const TrainingModeController({super.key});

  @override
  State<TrainingModeController> createState() => _TrainingModeControllerState();
}

class _TrainingModeControllerState extends State<TrainingModeController> {
  List<GameModel>_datas = [];
  
  // List View
  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      child: TrainingModeListView(
        model: _datas[index],
        scanBleList: () async {
          // 没有蓝牙设备则先提示去连接蓝牙设备，有设备则跳转到下一步
          if(BluetoothManager().conectedDeviceCount.value == 0){
            TTDialog.bleListDialog(context);
            print('没有连接的蓝牙设备，先蓝牙连接');
          }else{
            GameUtil gameUtil = GetIt.instance<GameUtil>();
            gameUtil.modelId = index + 1;
            NavigatorUtil.push(Routes.recordselect);
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
  }
  
  queryModeListData() async{
    final _response = await Participants.queryModelListData();
    if(_response.success && _response.data != null){
      _datas.addAll(_response.data!);
      setState(() {

      });
    }
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
                            image:
                                BluetoothManager().conectedDeviceCount.value > 0
                                    ? AssetImage('images/ble/ble_done.png')
                                    : AssetImage('images/ble/ble_not.png'),
                            width: 27,
                            height: 27,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Constants.regularWhiteTextWidget(
                              BluetoothManager()
                                  .conectedDeviceCount
                                  .value
                                  .toString(),
                              16),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: _datas.length ==  0 ? NoDataView() : ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 20),
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
