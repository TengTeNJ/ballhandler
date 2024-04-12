import 'package:code/constants/constants.dart';
import 'package:code/views/participants/today_data_list_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

import '../../services/http/airbattle.dart';

class MyActivityController extends StatefulWidget {
  const MyActivityController({super.key});

  @override
  State<MyActivityController> createState() => _MyActivityControllerState();
}

class _MyActivityControllerState extends State<MyActivityController> {
  late List<MyActivityModel> _datas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryMyActivityData();
  }

  queryMyActivityData() async{
    final _response =  await AirBattle.queryMyActivityData(1);
    if(_response.success && _response.data!=null){
      _datas.addAll(_response.data!);
    }else{
      _datas = [];
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
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Constants.boldWhiteTextWidget('My Activity', 30)
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(child: TodayDataListView(datas: _datas,))
          ],
        ),
      ),
    );
  }
}
