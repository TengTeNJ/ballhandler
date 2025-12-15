import 'package:code/views/stats/stats_line_area_view.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../controllers/ranking/my_stats_controller.dart';
import '../../models/mystats/my_stats_model.dart';
import '../../route/route.dart';
import '../../utils/color.dart';
import '../../utils/navigator_util.dart';
import '../airbattle/my_stats_line_area_view.dart';

class LineThumbnailView extends StatefulWidget {
  List<MyStatsModel> datas = [];

  LineThumbnailView({super.key, required this.datas});

  @override
  State<LineThumbnailView> createState() => _LineThumbnailViewState();
}

class _LineThumbnailViewState extends State<LineThumbnailView> {
  int _selectType = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        NavigatorUtil.push(Routes.statsdetail);
      },
      child: Container(
        padding: EdgeInsets.all(12),
        height: 146,
        width: (Constants.screenWidth(context) - 8 - 32) / 2.0,
        decoration: BoxDecoration(
            color: hexStringToColor('#3E3E55'),
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Constants.mediumGreyTextWidget('Trainings', 14),
                Image(
                  image: AssetImage('images/stats/next.png'),
                  width: 16,
                  height: 16,
                )
              ],
            ),
            Expanded(
                child: Center(
                  child: SizedBox(
                    width: (Constants.screenWidth(context) - 8 - 32) / 2.0 - 24,
                    child: SizedBox(
                      child: StatsLineAreaView(
                        datas: widget.datas,
                        selectType: _selectType,
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
