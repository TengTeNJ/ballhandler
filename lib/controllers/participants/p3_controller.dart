import 'package:camera/camera.dart';
import 'package:code/controllers/participants/p3_guide_controller.dart';
import 'package:code/route/route.dart';
import 'package:code/utils/toast.dart';
import 'package:code/views/participants/p3_grid_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../constants/constants.dart';
import '../../models/airbattle/p3_item_model.dart';
import '../../utils/color.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';

class P3Controller extends StatefulWidget {
  const P3Controller({super.key});

  @override
  State<P3Controller> createState() => _P3ControllerState();
}

class _P3ControllerState extends State<P3Controller> {
  List<P3ItemModel> _selectModels = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: Constants.darkControllerColor,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Stack(
          children: [
            Positioned(
                top: 42,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Constants.mediumWhiteTextWidget('Free Mode Training', 22),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Constants.mediumGreyTextWidget(
                            'Please select 3-5 training modes and combine them into one free mode for training',
                            14,
                            height: 1.2,
                            textAlign: TextAlign.start),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      P3GridListView(selectItem: (List<P3ItemModel> selectModels){
                        _selectModels.clear();
                        _selectModels.addAll(selectModels);
                        setState(() {

                        });
                      },),
                      SizedBox(
                        height: 156,
                      ),
                    ],
                  ),
                )),
            Positioned(
              top: 16,
              left: 0,
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
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
                            image:
                                AssetImage('images/participants/back_grey.png'),
                            width: 16,
                            height: 12,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 44,
                left: 24,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    if(_selectModels.length > 0){
                      GameUtil gameUtil = GetIt.instance<GameUtil>();
                      gameUtil.selectdP3Indexs.clear();
                      // 记录选择的P3模式的索引组合
                      _selectModels.forEach((element){
                        gameUtil.selectdP3Indexs.add(element.index);
                      });
                      NavigatorUtil.present(P3GuideController(selectModels: _selectModels,));
                    }
                  },
                  child: Container(
                      width: Constants.screenWidth(context) - 48,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient:  _selectModels.length > 0 ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(182, 246, 29, 1.0),
                            Color.fromRGBO(219, 219, 20, 1.0)
                          ],
                        ) : LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          hexStringToColor('#B5B5B5'),
                          hexStringToColor('#717171'),
                        ] ,
                      )),
                      child: Center(
                        child: Constants.boldBlackTextWidget('Continue', 16),
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
