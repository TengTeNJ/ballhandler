import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../route/route.dart';
import '../../utils/color.dart';
import '../../utils/navigator_util.dart';

class MilestoneThumbnailView extends StatefulWidget {
  const MilestoneThumbnailView({super.key});

  @override
  State<MilestoneThumbnailView> createState() => _MilestoneThumbnailViewState();
}

class _MilestoneThumbnailViewState extends State<MilestoneThumbnailView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        NavigatorUtil.push(Routes.careerdetail);
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('images/profile/dark_blue_icon.png'),
                        width: 49,
                        height: 49,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Constants.mediumWhiteTextWidget('500PTS', 14)
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
