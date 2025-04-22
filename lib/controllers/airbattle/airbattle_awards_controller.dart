import 'package:code/models/airbattle/award_view_model.dart';
import 'package:code/views/airbattle/airbattle_award_view.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../widgets/navigation/CustomAppBar.dart';

class AirBattleAwardsController extends StatefulWidget {
  const AirBattleAwardsController({super.key});

  @override
  State<AirBattleAwardsController> createState() =>
      _AirBattleAwardsControllerState();
}

class _AirBattleAwardsControllerState extends State<AirBattleAwardsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(
        showBack: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Constants.boldWhiteTextWidget('Awards', 30),
            SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.only(
                  left: (Constants.screenWidth(context) - 303) / 2.0,
                  right: (Constants.screenWidth(context) - 303) / 2.0),
              height: 163,
              width: 303,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,right: 0,top: 0,bottom: 25,
                      child: Image(
                          image:
                              AssetImage('images/participants/fireworks.png'))),
                  Positioned(
                      left: 55,right: 55,top: 56,bottom: 0,
                      child: Image(
                          image:
                          AssetImage('images/airbattle/product.png')))
                ],
              ),
            ),
            SizedBox(height: 60,),
            AirBattleAwardView(model: AwardViewModel(title: 'Top Performer', imageName: 'images/airbattle/top.png', detail: ' Free Ultimater Dangler 2.0')),
            SizedBox(height: 16,),
            AirBattleAwardView(model: AwardViewModel(title: 'Rising Star', imageName: 'images/airbattle/rising.png', des: ' (Most Improved)', detail: ' \$25 Store Cash')),
            SizedBox(height: 16,),
            AirBattleAwardView(model: AwardViewModel(title: 'Consistent Contender', imageName: 'images/airbattle/consistent.png', detail: ' \$25 Store Cash')),

          ],
        ),
      ),
    );
  }
}
