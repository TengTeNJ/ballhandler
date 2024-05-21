import 'package:code/constants/constants.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/toast.dart';
import 'package:code/widgets/video/video_play_view.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/color.dart';
import '../../utils/navigator_util.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class VideoGuideController extends StatefulWidget {
  String videoPath;
  VideoGuideController({required this.videoPath});

  @override
  State<VideoGuideController> createState() => _VideoGuideControllerState();
}

class _VideoGuideControllerState extends State<VideoGuideController> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 100,
              bottom: 130,
              child: VideoPlayView(
                videoPath: widget.videoPath ?? '',
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
                  if (widget.videoPath.contains('http')) {
                    _downloadAndShareVideo(widget.videoPath);
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
