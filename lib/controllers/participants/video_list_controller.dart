import 'package:code/constants/constants.dart';
import 'package:code/services/http/profile.dart';
import 'package:code/views/participants/video_list_view.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../../widgets/navigation/CustomAppBar.dart';

class VideoListController extends StatefulWidget {
  const VideoListController({super.key});

  @override
  State<VideoListController> createState() => _VideoListControllerState();
}

class _VideoListControllerState extends State<VideoListController> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: true,
      ),
      backgroundColor: Constants.darkThemeColor,
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Constants.boldWhiteTextWidget('Video list', 30,
                textAlign: TextAlign.left),
            SizedBox(
              height: 32,
            ),
            Expanded(child: VideoListView())
          ],
        ),
      ),
    );
  }
}
