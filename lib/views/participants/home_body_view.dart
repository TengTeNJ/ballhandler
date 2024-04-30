
import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/global.dart';

class HomeBodyView extends StatefulWidget {
  const HomeBodyView({super.key});

  @override
  State<HomeBodyView> createState() => _HomeBodyViewState();
}

class _HomeBodyViewState extends State<HomeBodyView> {
  bool _start = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage('images/participants/background.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 49, left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('images/participants/icon_white.png'),
                  width: 62,
                  height: 63,
                ),
                SizedBox(
                  height: 8,
                ),
                Constants.boldWhiteTextWidget(
                  'Digital Stickhandling Trainer',
                  26,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  // color: Colors.red,
                  child: Constants.regularWhiteTextWidget('Sharpen your stickhandling and reaction time with interactive challenges that also encourage you to glance up and maintain awareness. Watch yourself in action and perfect your technique in real-time.Select your challenge mode by shape, dive into quick tutorials,and push your limits.', 10,height: 1.5),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async{
             // TTDialog.timeSelect(context);
             //  TTDialog.airplayDialog(context);
              GameUtil gameUtil = GetIt.instance<GameUtil>();
              gameUtil.isFromAirBattle = false;
              NavigatorUtil.push('trainingMode');
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 16, left: 56, right: 56),
              height: 43,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromRGBO(182, 246, 29, 1.0),
                    Color.fromRGBO(219, 219, 20, 1.0)
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Constants.boldBlackTextWidget('Play Now', 16),
                  ),
                  Positioned(
                      top: 6,
                      right: 6,
                      child: Image(
                        image: AssetImage('images/participants/next.png'),
                        width: 31,
                        height: 31,
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
