import 'package:code/models/game/game_over_model.dart';
import 'package:code/views/participants/player_bottom_view.dart';
import 'package:code/widgets/video/video_play_view.dart';
import 'package:flutter/material.dart';
import '../../utils/color.dart';
import '../../utils/navigator_util.dart';
import 'package:share_plus/share_plus.dart';

class VideoPlayController extends StatefulWidget {
  bool? fromGameFinishPage = false;
  GameOverModel model;

  VideoPlayController({required this.model,this.fromGameFinishPage});

  @override
  State<VideoPlayController> createState() => _VideoPlayControllerState();
}

class _VideoPlayControllerState extends State<VideoPlayController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          VideoPlayView(
            videoPath: widget.model.videoPath ?? '',
          ),
          Positioned(
              left: 16,
              top: 60,
              child: GestureDetector(
                onTap: () {
                  NavigatorUtil.pop();
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: hexStringToColor('#65657D')),
                  child: Center(
                    child: Image(
                      image: AssetImage('images/participants/back_grey.png'),
                      width: 16,
                      height: 12,
                    ),
                  ),
                ),
              )),
          Positioned(
              right: 16,
              top: 60,
              child: GestureDetector(
                onTap: () {
                  print('share---');
                  XFile file = XFile(widget.model.videoPath);
                  Share.shareXFiles([file], text: "Good Game");
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: hexStringToColor('#65657D')),
                  child: Center(
                    child: Image(
                      image: AssetImage('images/participants/share.png'),
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
              )),
          Positioned(
              left: 16,
              right: 16,
              bottom: 32,
              child: PlayerBottomView(model: widget.model))
        ],
      ),
    );
  }
}
