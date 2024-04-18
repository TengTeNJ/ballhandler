import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayView extends StatefulWidget {
  String videoPath;

  VideoPlayView({required this.videoPath});

  @override
  State<VideoPlayView> createState() => _VideoPlayViewState();
}

class _VideoPlayViewState extends State<VideoPlayView> {
  late final VideoPlayerController _controller;
  late ChewieController _chewieController;
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.videoPath.contains('http')) {
      print(123);
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
            ..initialize().then((value) {
              // 加载完成
              //_controller.play();
              _loading = false;
              setState(() {});
            });
    } else {
      File file = File(widget.videoPath);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((value) {
          // 加载完成
         // _controller.play();
          _loading = false;
          setState(() {});
        });
    }
    _chewieController = ChewieController(
      videoPlayerController: _controller,
    );
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        :   Chewie(controller: _chewieController) ;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
  }
}
