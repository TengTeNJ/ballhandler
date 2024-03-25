import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:code/widgets/video/video_play_view.dart';
import 'package:flutter/material.dart';
class VideoPlayController extends StatefulWidget {
  String videoPath;
  VideoPlayController({required this.videoPath});

  @override
  State<VideoPlayController> createState() => _VideoPlayControllerState();
}

class _VideoPlayControllerState extends State<VideoPlayController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBack: true,),
      body: VideoPlayView(videoPath: widget.videoPath,),
    );

  }
}
