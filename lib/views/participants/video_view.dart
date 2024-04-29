import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/services/http/profile.dart';
import 'package:code/utils/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import '../../utils/navigator_util.dart';

class VideoView extends StatefulWidget {
  VideoModel videoModel;

  VideoView({required this.videoModel});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  Uint8List _imageUrl = Uint8List.fromList([]);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadThumbailImage();
  }

  loadThumbailImage() async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: widget.videoModel.trainVideo,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 150, // 宽度
      quality: 50, // 质量
    );
    if (uint8list != null) {
      setState(() {
        _imageUrl = uint8list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            width: 150,
            height: 120,
            child: Stack(
              children: [
                _imageUrl.length > 0
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          _imageUrl,
                          height: 120,
                          width: 150,
                          fit: BoxFit.fill,
                        ),
                      )
                    : Container(),
                Align(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      // 跳转到视频播放页面
                      GameOverModel model = GameOverModel();
                      model.modeId = widget.videoModel.modeId;
                      model.sceneId = widget.videoModel.sceneId;
                      model.videoPath = widget.videoModel.trainVideo;
                      model.score = widget.videoModel.trainScore;
                      model.avgPace = widget.videoModel.avgPace;
                      model.endTime = widget.videoModel.createTime;
                      NavigatorUtil.push('videoPlay', arguments: {
                        "model": model,
                        "gameFinish": false
                      });
                    },
                    child: Icon(
                      Icons.play_arrow,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Constants.boldWhiteTextWidget(
                  kGameSceneAndModelMap[widget.videoModel.sceneId]![
                          widget.videoModel.modeId] ??
                      'ZIGZAG Challenge',
                  16),
              SizedBox(
                height: 36,
              ),
              Constants.mediumWhiteTextWidget(
                  '${widget.videoModel.avgPace}', 16),
              SizedBox(
                height: 4,
              ),
              Constants.regularGreyTextWidget(
                  StringUtil.serviceStringToShowMinuteString(
                      widget.videoModel.createTime),
                  14),
            ],
          )
        ],
      ),
    );
  }
}
