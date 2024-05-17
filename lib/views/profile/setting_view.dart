import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class SettingView extends StatefulWidget {
  List<String> datas;
  List<String> detailTitles;
  List<bool> showArrows;

  String title;
  Function? selectItem;

  SettingView(
      {required this.title,
      required this.datas,
      this.selectItem,
      required this.detailTitles,
      required this.showArrows});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Constants.mediumWhiteTextWidget(widget.title, 20),
        SizedBox(
          height: 8,
        ),
        Column(
          children: List.generate(widget.datas.length, (index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // 点击cell
                if (widget.showArrows[index]) {
                  if (widget.selectItem != null) {
                    widget.selectItem!(index);
                  }
                }
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Constants.regularGreyTextWidget(widget.datas[index], 18),
                      Row(
                        children: [
                          Constants.regularGreyTextWidget(
                              widget.detailTitles[index], 18),
                          SizedBox(
                            width: 12,
                          ),
                          widget.showArrows[index]
                              ? Image(
                                  image: AssetImage(
                                      'images/airbattle/next_white.png'),
                                  width: 12,
                                  height: 12,
                                )
                              : Container()
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    color: hexStringToColor('#707070'),
                    height: 0.5,
                  ),
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}
