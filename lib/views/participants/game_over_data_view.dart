import 'dart:io';

import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../utils/global.dart';

class GameOverDataView extends StatefulWidget {
  final GameOverModel dataModel;

  GameOverDataView({required this.dataModel});

  @override
  State<GameOverDataView> createState() => _GameOverDataViewState();
}

class _GameOverDataViewState extends State<GameOverDataView> {
  final _titles = ['Time', 'Score', 'Integral'];
  late final _datas;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _datas = [
      widget.dataModel.time,
      widget.dataModel.score.toString(),
      widget.dataModel.Integral
    ];
  }

  @override
  Widget build(BuildContext context) {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    return Container(
      decoration: BoxDecoration(
          color: hexStringToColor('#17171D'),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Constants.baseStyleColor)),
      width: Constants.screenWidth(context) - 63,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 34,
          ),
          Column(
            children: [
              Constants.boldWhiteTextWidget(
                  '${widget.dataModel.avgPace.toString()}', 40),
              Constants.regularBaseTextWidget('Avg.pace', 14),
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
              gameUtil.selectRecord ? GestureDetector(
                child: Container(
                  width: 24,
                  height: 24,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: FutureBuilder<String?>(
                          future: VideoThumbnail.thumbnailFile(
                            video: widget.dataModel.videoPath??'',
                            imageFormat: ImageFormat.PNG,
                            maxWidth: 24,
                            quality: 50,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.data != null) {
                              return Image.file(
                                  width: 24, height: 24, File(snapshot.data!));
                            } else if (snapshot.error != null) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Image(
                          image: AssetImage('images/participants/play.png'),
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  print('播放视频');
                  NavigatorUtil.push('videoPlay',
                      arguments: widget.dataModel);
                },
              ) : Container(),
              SizedBox(
                width: 12,
              ),
              Constants.regularWhiteTextWidget('Training video', 14),
            ],
          )),
        ],
      ),
    );
  }
}
