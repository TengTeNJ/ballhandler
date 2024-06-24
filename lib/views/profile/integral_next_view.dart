import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

import '../../services/http/profile.dart';

class IntegralNextView extends StatefulWidget {
  MyAccountDataModel model;

  IntegralNextView({required this.model});

  @override
  State<IntegralNextView> createState() => _IntegralNextViewState();
}

class _IntegralNextViewState extends State<IntegralNextView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      width: Constants.screenWidth(context) - 32,
      decoration: BoxDecoration(
          color: hexStringToColor('#292936'),
          borderRadius: BorderRadius.circular(5)),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              // color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(
                        'images/profile/progress_${widget.model.memberLevel}.png'),
                    width: 37,
                    height: 42,
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Container(
                    width: Constants.screenWidth(context) - 37 - 32 - 24 - 24 - 32 ,
                    height: 43,
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Constants.regularGreyTextWidget('Next Level', 14,height: 1.0),
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: widget.model.integral.toString(),
                                    style: TextStyle(
                                        fontFamily: 'SanFranciscoDisplay',
                                        color: Constants.baseStyleColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,height: 1.0),
                                  ),
                                  TextSpan(
                                    text:
                                    '/${widget.model.upperLimit.toString()}',
                                    style: TextStyle(
                                        fontFamily: 'SanFranciscoDisplay',
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,height: 1.0),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        LinearProgressIndicator(
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(10),
                          value:
                          widget.model.integral / widget.model.upperLimit,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Constants.baseStyleColor),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            top: 25,
            left: 24,
            right: 32,
          ),
          Positioned(
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 24 + 37 + 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.help,
                      color: hexStringToColor('#B1B1B1'),
                      size: 12,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Constants.regularGreyTextWidget(
                        'Points will be cleared in January ${DateTime.now().year + 1}',
                        10)
                  ],
                ),
              ),
              bottom: 6),
        ],
      ),
    );
  }
}
