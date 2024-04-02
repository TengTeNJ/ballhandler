import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class VideoPlayView extends StatefulWidget {
  String videoPath;
  VideoPlayView({required this.videoPath});

  @override
  State<VideoPlayView> createState() => _VideoPlayViewState();
}

class _VideoPlayViewState extends State<VideoPlayView> {
  late final  VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    File file = File(widget.videoPath);
    _controller = VideoPlayerController.file(file)..initialize();
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_controller);
  }
}
