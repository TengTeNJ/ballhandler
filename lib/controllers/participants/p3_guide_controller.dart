import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../models/airbattle/p3_item_model.dart';
import '../../route/route.dart';
import '../../utils/color.dart';
import '../../utils/navigator_util.dart';
import '../../utils/toast.dart';

class P3GuideController extends StatefulWidget {
  List<P3ItemModel> selectModels = [];

  P3GuideController({required this.selectModels});

  @override
  State<P3GuideController> createState() => _P3GuideControllerState();
}

class _P3GuideControllerState extends State<P3GuideController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: Constants.darkThemeColor,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
               child: Column(
                 children: [
                   SizedBox(height: 59,),
                   Constants.mediumWhiteTextWidget('P3 Free Mode Training', 24),
                   SizedBox(height: 62,),
                   Expanded(child: ListView.separated(
                       itemBuilder: (context, index) {
                         return Padding(
                           padding: EdgeInsets.only(left: 42, right: 42),
                           child:  (widget.selectModels.length ) == index  ? SizedBox(height: 338,) : Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Image(
                                 image: AssetImage(
                                     'images/p3/${p3Maps[widget.selectModels[index].index]!['image']}.png'),
                                 width: Constants.screenWidth(context) - 84,
                               ),
                               SizedBox(height: 34,),
                               Constants.regularWhiteTextWidget( '${p3Maps[widget.selectModels[index].index]!['title']}' + '(' + widget.selectModels[index].timeString + ' seconds' +  ')', 14,height: 1.2),
                             Constants.regularGreyTextWidget( '${p3Maps[widget.selectModels[index].index]!['des']}' ,14,textAlign: TextAlign.start,height: 1.2),
                             ],
                           ),
                         );
                       },
                       separatorBuilder: (context, index) {
                         return SizedBox(
                           height: 45,
                         );
                       },
                       itemCount: widget.selectModels.length + 1)),
                 ],
               ),
                ),
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
                    TTToast.showLoading();
                    NavigatorUtil.pop();
                    List<CameraDescription> cameras = await availableCameras();
                    NavigatorUtil.push(Routes.p3check,
                        arguments: cameras[cameras.length > 1 ? 1 : 0]);
                    TTToast.hideLoading();
                  },
                  child: Container(
                      width: Constants.screenWidth(context) - 48,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(182, 246, 29, 1.0),
                            Color.fromRGBO(219, 219, 20, 1.0)
                          ],
                        ),
                      ),
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
