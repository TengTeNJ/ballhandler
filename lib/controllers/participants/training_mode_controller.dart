import 'package:code/constants/constants.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/views/participants/training_mode_list_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrainingModeController extends StatefulWidget {
  const TrainingModeController({super.key});

  @override
  State<TrainingModeController> createState() => _TrainingModeControllerState();
}

class _TrainingModeControllerState extends State<TrainingModeController> {
  // List View
  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      child: TrainingModeListView(scanBleList: (){
       print('去预览页面');
      },),
    );
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
                            image: AssetImage('images/ble/ble_not.png'),
                            width: 27,
                            height: 27,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Constants.regularWhiteTextWidget('0', 16),
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
}
