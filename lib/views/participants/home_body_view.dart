import 'package:code/constants/constants.dart';
import 'package:code/services/http/participants.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/event_track.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/account/login_page_controller.dart';
import '../../models/global/user_info.dart';
import '../../utils/global.dart';

class HomeBodyView extends StatefulWidget {
  final SceneModel model;
  final bool isActive; // 👈 是否当前可见页

  HomeBodyView({
    required this.model,
    required this.isActive,
  });

  @override
  State<HomeBodyView> createState() => _HomeBodyViewState();
}

class _HomeBodyViewState extends State<HomeBodyView> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _initVideo() async {
    if (!ISEmpty(widget.model.videoUrl)) {
      _videoController = VideoPlayerController.asset(widget.model.videoUrl)
        ..initialize().then((_) {
          if (!mounted) return;
          setState(() {});
          _videoController!
            ..setLooping(true)
            ..setVolume(0);

          if (widget.isActive) {
            _videoController!.play();
          }
        });
    }
  }

  @override
  void didUpdateWidget(covariant HomeBodyView oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// 🔥 非当前页自动暂停 / 当前页自动播放
    if (_videoController != null && _videoController!.value.isInitialized) {
      if (widget.isActive) {
        _videoController!.play();
      } else {
        _videoController!.pause();
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          /// 🎥 背景视频
          Positioned.fill(child: _buildBackground()),

          /// 🌫️ 蒙版（科技感 + 提升文字对比度）
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),

          /// 📦 内容层（完全不动）
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _videoController!.value.size.width,
          height: _videoController!.value.size.height,
          child: VideoPlayer(_videoController!),
        ),
      );
    }

    /// 兜底图片
    return Image(
      image: (widget.model.dictImage.length > 0)
          ? NetworkImage(widget.model.dictImage)
          : AssetImage('images/participants/background${widget.model.dictKey}.png')
      as ImageProvider,
      fit: BoxFit.cover,
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Container(
          margin: EdgeInsets.only(top: 49, left: 0, right: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Image(
                  image: AssetImage(
                      'images/participants/product_${widget.model.dictKey}.png'),
                  width: double.infinity,
                  height: 72,
                ),
              ),
              SizedBox(height: 8),
              Constants.boldWhiteTextWidget(
                ISEmpty(widget.model.title)
                    ? widget.model.dictValue
                    : widget.model.title,
                26,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
             Container(child:  Constants.boldWhiteTextWidget(
               widget.model.dictRemark,
               12,
               height: 1.5,
             )),
            ],
          ),
        ),),
        GestureDetector(
          onTap: () async {
            final _hasLogin = UserProvider.of(context).hasLogin;
            if (_hasLogin == false) {
              NavigatorUtil.present(LoginPageController());
              return;
            }
            EventTrackUtil.eventTrack(kPlayNow, {});
            GameUtil gameUtil = GetIt.instance<GameUtil>();
            gameUtil.isFromAirBattle = false;
            gameUtil.selectRecord = false;
            NavigatorUtil.push('trainingMode');
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16, left: 56, right: 56),
            height: 43,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  hexStringToColor(widget.model.gradientStart),
                  hexStringToColor(widget.model.gradientEnd),
                ],
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12), // 左边留点边距（可选）

                /// 剩余空间
                Expanded(
                  child: Center(
                    child: widget.model.gradientStart == '#B6F61D'
                        ? Constants.boldBlackTextWidget(
                      !ISEmpty(widget.model.buttonName)
                          ? widget.model.buttonName
                          : 'PLAY NOW',
                      16,
                    )
                        : Constants.boldWhiteTextWidget(
                      !ISEmpty(widget.model.buttonName)
                          ? widget.model.buttonName
                          : 'PLAY NOW',
                      16,
                    ),
                  ),
                ),

                /// 右侧固定图标
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    'images/participants/next.png',
                    width: 31,
                    height: 31,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
