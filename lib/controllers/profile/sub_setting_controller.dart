import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

class SubSettingController extends StatefulWidget {
  String title;
  String? subTitle;
  int switchCount ;

  SubSettingController({required this.title, this.subTitle,this.switchCount = 1});

  @override
  State<SubSettingController> createState() => _SubSettingControllerState();
}

class _SubSettingControllerState extends State<SubSettingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(
        showBack: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Constants.boldWhiteTextWidget(widget.title, 30,textAlign: TextAlign.left),
            SizedBox(
              height: 48,
            ),
            widget.subTitle != null
                ? Constants.regularWhiteTextWidget(widget.subTitle!, 16,textAlign: TextAlign.left,height: 1.2)
                : Container(),
            widget.subTitle != null ?  SizedBox(
              height: 20,
            ) :Container(),
            Expanded(child: ListView.separated(
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Constants.regularWhiteTextWidget('ON', 16),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: hexStringToColor('#292936'),
                                border: Border.all(
                                    color: hexStringToColor('#707070'),
                                    width: 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: hexStringToColor('#F8850B'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 1,
                        color: hexStringToColor('#707070'),
                      )
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 36,
                  );
                },
                itemCount: widget.switchCount))
          ],
        ),
      ),
    );
  }
}
