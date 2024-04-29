import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/services/http/participants.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/toast.dart';
import 'package:code/views/participants/player_bottom_view.dart';
import 'package:code/widgets/video/video_play_view.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/color.dart';
import '../../utils/navigator_util.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class VideoPlayController extends StatefulWidget {
  bool? fromGameFinishPage = false;
  GameOverModel model;

  VideoPlayController({required this.model, this.fromGameFinishPage});

  @override
  State<VideoPlayController> createState() => _VideoPlayControllerState();
}

class _VideoPlayControllerState extends State<VideoPlayController> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      queryRankBaseScore();
  }

  /*根据得分查询排名数据*/
  queryRankBaseScore() async {
    final _response =
        await Participants.queryRankBaseScore(widget.model.avgPace);
    widget.model.rank = _response.data ?? '--';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      body: Stack(
        children: [
          // Align(alignment: Alignment.center,
          //   child: VideoPlayView(
          //     videoPath: widget.model.videoPath ?? '',
          //   ),
          // ),
          Positioned(
            left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: VideoPlayView(
            videoPath: widget.model.videoPath ?? '',
          )),
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
                onTap: () async {
                  if (widget.model.videoPath.contains('http')) {
                    _downloadAndShareVideo(widget.model.videoPath);
                  } else {
                    XFile file = XFile(widget.model.videoPath);
                    Share.shareXFiles([file], text: "Good Game");
                  }
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
              bottom: 44,
              child: PlayerBottomView(model: widget.model))
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

/* 先把视频下载到本地，然后再分享*/
Future<void> _downloadAndShareVideo(String videoUrl) async {
  TTToast.showLoading();
  final appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String savePath = appDocumentsDirectory.path + '/video.mp4';
  final response = await dio.download(videoUrl, savePath);
  TTToast.hideLoading();
  await Share.shareXFiles([XFile(savePath)]);
  // 分享完成，删除视频
  final file = File(savePath);
  if (file.existsSync()) {
    file.deleteSync();
  }
}
