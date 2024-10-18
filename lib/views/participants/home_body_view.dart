import 'package:code/constants/constants.dart';
import 'package:code/services/http/participants.dart';
import 'package:code/utils/event_track.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../utils/global.dart';

class HomeBodyView extends StatefulWidget {
  SceneModel model;
   HomeBodyView({required this.model});

  @override
  State<HomeBodyView> createState() => _HomeBodyViewState();
}

class _HomeBodyViewState extends State<HomeBodyView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage('images/participants/background${widget.model.dictKey}.png'),
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
                  image: AssetImage(
                      'images/participants/product_${widget.model.dictKey}.png'),
                  width: 62,
                  height: 63,
                ),
                SizedBox(
                  height: 8,
                ),
                Constants.boldWhiteTextWidget(
                  widget.model.dictValue,
                  26,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  // color: Colors.red,
                  child: Constants.regularWhiteTextWidget(widget.model.dictRemark,10,height: 1.5),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async{
              EventTrackUtil.eventTrack(kPlayNow,{});
              GameUtil gameUtil = GetIt.instance<GameUtil>();
              gameUtil.isFromAirBattle = false;
              gameUtil.selectRecord = false;
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
