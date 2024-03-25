import 'package:code/constants/constants.dart';
import 'package:code/views/participants/today_data_list_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

class TodayDataController extends StatefulWidget {
  const TodayDataController({super.key});

  @override
  State<TodayDataController> createState() => _TodayDataControllerState();
}

class _TodayDataControllerState extends State<TodayDataController> {
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
                Constants.boldWhiteTextWidget('Today’s Challenge', 30)
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(child: TodayDataListView())
          ],
        ),
      ),
    );
  }
}
