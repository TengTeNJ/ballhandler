
import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../utils/global.dart';

class GameOverDataView extends StatefulWidget {
  final GameOverModel dataModel;

  GameOverDataView({required this.dataModel});

  @override
  State<GameOverDataView> createState() => _GameOverDataViewState();
}

class _GameOverDataViewState extends State<GameOverDataView> {
  final _titles = ['Time(sec)', 'Score', 'Pucks'];
  late final _datas;
  String mode = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getModeAndTimeString();
  }

  getModeAndTimeString() {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
      String timeString = widget.dataModel.time;
    _datas = [
      StringUtil.timeStringFormat(timeString),
      widget.dataModel.score.toString(),
      widget.dataModel.Integral
    ];
    Map? _map =
        kGameSceneAndModelMap[(gameUtil.gameScene.index + 1).toString()];
    if (_map != null) {
      String text = _map[gameUtil.modelId.toString()];
      mode = text;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    return Container(
      decoration: BoxDecoration(
          color: hexStringToColor('#17171D'),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.5, color: Constants.baseStyleColor)),
      width: Constants.screenWidth(context) - 63,
      height: 285,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 16,
          ),
          Constants.regularGreyTextWidget(mode, 14),
          SizedBox(
            height: 16,
          ),
          Column(
            children: [
              Constants.boldWhiteTextWidget(
                  '${widget.dataModel.avgPace.toString()}', 40),
              Constants.regularBaseTextWidget('Avg.pace(s/pt)', 14),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: (Constants.screenWidth(context) - 96),
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width:
                              (Constants.screenWidth(context) - 96 - 1.5) / 3.0,
                          // color: Colors.blue,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Constants.boldWhiteTextWidget(_datas[index], 24),
                              Constants.regularBaseTextWidget(
                                  _titles[index], 14),
                            ],
                          ),
                        ),
                        index != (_titles.length - 1)
                            ? Container(
                                height: 40,
                                width: 0.5,
                                color: Color.fromRGBO(86, 86, 116, 1.0),
                              )
                            : Container(),
                      ],
                    ));
              }),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Container(
            color: hexStringToColor('#565674'),
            height: 1,
            width: Constants.screenWidth(context) - 96,
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if ((gameUtil.selectRecord || gameUtil.isFromAirBattle)) {
                    NavigatorUtil.push('videoPlay', arguments: {
                      "model": widget.dataModel,
                      "gameFinish": true
                    });
                  }
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        color:
                            (gameUtil.selectRecord || gameUtil.isFromAirBattle)
                                ? Colors.white
                                : Constants.baseGreyStyleColor,
                        size: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      (gameUtil.selectRecord || gameUtil.isFromAirBattle)
                          ? Constants.regularWhiteTextWidget(
                              'Training video', 14)
                          : Constants.regularGreyTextWidget(
                              'Training video', 14),
                    ],
                  ),
                  height: 35,
                  width: 185,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: (gameUtil.selectRecord || gameUtil.isFromAirBattle)
                        ? hexStringToColor('#3A3A51')
                        : hexStringToColor('#848484'),
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
