import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

class SubscribeBorderView extends StatefulWidget {
  String leftTitle;
  String rightTitle;
  String? rightDes;

  SubscribeBorderView(
      {required this.leftTitle, required this.rightTitle, this.rightDes});

  @override
  State<SubscribeBorderView> createState() => _SubscribeBorderViewState();
}

class _SubscribeBorderViewState extends State<SubscribeBorderView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/participants/subscribe_border.png'),
              fit: BoxFit.fill)),
      child: Padding(
        padding: EdgeInsets.only(left: 18, right: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Constants.boldWhiteTextWidget(widget.leftTitle, 20),
            widget.rightDes != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Constants.boldBaseTextWidget(
                              '${widget.rightTitle}', 20),
                          Constants.regularBaseTextWidget('/mo', 14),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Constants.regularGreyTextWidget(
                          'Billed as ${widget.rightDes}/yr', 14)
                    ],
                  )
                : Row(
                    children: [
                      Constants.boldBaseTextWidget('\$${widget.rightTitle}', 20),
                      Constants.regularBaseTextWidget('/mo', 14),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
