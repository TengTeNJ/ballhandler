import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/route/route.dart';
import 'package:code/services/http/participants.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../utils/global.dart';

class TrainingModeListView extends StatefulWidget {
  GameModel model;
  final void Function()? scanBleList;

  TrainingModeListView({this.scanBleList, required this.model});

  @override
  State<TrainingModeListView> createState() => _TrainingModeListViewState();
}

class _TrainingModeListViewState extends State<TrainingModeListView> {
  int _joinCount = 0;
  int _sceneId = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryJoinCountData();
   setState(() {
     GameUtil gameUtil = GetIt.instance<GameUtil>();
     _sceneId = gameUtil.gameScene.index + 1;
   });
  }

  queryJoinCountData() async {
    final _token = await NSUserDefault.getValue(kAccessToken);
    // 登录了才进行数据请求
    if (_token != null && _token.length > 0) {
      final _response = await Participants.queryJoinCount(widget.model.modeId);
      if (_response.success && _response.data != null) {
        _joinCount = _response.data!.trainMemberCount;
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.scanBleList != null) {
          widget.scanBleList!();
        }
      },
      child: Container(
        margin: EdgeInsets.only(
            left: 16,
            right: 16),
        height: (Constants.screenWidth(context) - 32)*205/343,
        width: Constants.screenWidth(context) - 32,
        decoration: BoxDecoration(
          // color: Colors.red,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage('images/ble/ble_bg_new${_sceneId}.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 16, top: 21, right: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('images/participants/icon_white.png'),
                    width: 31,
                    height: 31,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                      constraints: BoxConstraints(
                          maxWidth: Constants.screenWidth(context) - 124),
                      child: Text(
                        widget.model.modeName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            height: 0.7,
                            fontFamily: 'SanFranciscoDisplay',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      )),
                  SizedBox(
                    width: 2,
                  ),
                  widget.model.modeVideo.contains('http') ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (widget.model.modeVideo.contains('http')) {
                        // TTDialog.videiGuideAidlog(context, widget.model.modeVideo);
                        NavigatorUtil.push(Routes.videoguide,arguments: widget.model.modeVideo);
                        print('跳转到视频介绍界面');
                      } else {
                        TTToast.showToast('No instruction video yet');
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(6),
                        width: 16,
                        height: 16,
                        child: Image(
                          image: AssetImage('images/participants/question.png'),
                        )),
                  ) : Container(),
                ],
              ),
            ),
            widget.model.difficultyLevel > 0
                ? Container(
                    width: Constants.screenWidth(context) - 32,
                    height: 20,
                    margin: EdgeInsets.only(top: 10, left: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Constants.regularWhiteTextWidget('Difficulty -', 12),
                        SizedBox(
                          width: 4,
                        ),
                        Row(
                          children: List.generate(widget.model.difficultyLevel,
                              (index) {
                            return Image(
                              image: AssetImage(
                                  'images/participants/five_star.png'),
                              width: 8,
                              height: 7.65,
                            );
                          }),
                        )
                      ],
                    ),
                  )
                : SizedBox(
                    height: 14,
                  ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 3),
              height: 47,
              child: SingleChildScrollView(
                child: Constants.customTextWidget(
                    widget.model.modeRemark, 14, '#CBCBCB',
                    height: 1.3, textAlign: TextAlign.start),
              ),
            ),
            Expanded(
                child: Container(
              // color: Colors.green,
              margin: EdgeInsets.only(left: 16, right: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Container(
                    child: Consumer<UserModel>(builder: (context, user, child) {
                      return Row(
                        children: [
                          // Time
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                image:
                                    AssetImage('images/participants/time.png'),
                                width: 16.8,
                                height: 16.8,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Constants.regularWhiteTextWidget(
                                      StringUtil.timeStringFormat(widget.model.trainTime),
                                      14),
                                  Constants.regularWhiteTextWidget('Time', 12),
                                ],
                              )
                            ],
                          ),
                          // Participants
                          SizedBox(
                            width: 27,
                          ),
                          user.hasLogin == true
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          'images/participants/person.png'),
                                      width: 16.8,
                                      height: 16.8,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Constants.regularWhiteTextWidget(
                                            _joinCount.toString(), 14),
                                        Constants.regularWhiteTextWidget(
                                            'Participants', 12),
                                      ],
                                    )
                                  ],
                                )
                              : Container(),
                        ],
                      );
                    }),
                  )),
                  // ClipOval(
                  //   child: Image(
                  //     image: AssetImage('images/participants/next_green.png'),
                  //     filterQuality: FilterQuality.high,
                  //     width: 55,
                  //     height: 55,
                  //     fit: BoxFit.fill,
                  //   ),
                  // ),
                ],
              ),
            )),
            // SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }
}
