import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

class SubscribeNewBorderView extends StatefulWidget {
  String leftTitle;
  String rightTitle;
  String unitText;
  String? des;
  Function? onTap;

  SubscribeNewBorderView({required this.leftTitle, required this.rightTitle,this.des,this.unitText = '/yr',this.onTap});

  @override
  State<SubscribeNewBorderView> createState() => _SubscribeNewBorderViewState();
}

class _SubscribeNewBorderViewState extends State<SubscribeNewBorderView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        if(widget.onTap != null){
          widget.onTap!();
        }
      },
      child: Container(
        height: 64,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/participants/subscribe_border.png'),
                fit: BoxFit.fill)),
        child: Padding(
          padding: EdgeInsets.only(left: 18, right: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Constants.boldWhiteTextWidget(widget.leftTitle, 20),
                  SizedBox(width: widget.des != null ? 8 : 0,),
                  widget.des != null
                      ? Container(
                    height: 20,
                    decoration: BoxDecoration(
                        color: Constants.baseStyleColor,
                        borderRadius: BorderRadius.circular(8)),
                    child:
                    Padding(padding: EdgeInsets.all(2),child: Constants.regularWhiteTextWidget(widget.des!, 14),),
                  )
                      : Container()
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Constants.boldBaseTextWidget(widget.rightTitle, 20),
                  SizedBox(
                    width: 6,
                  ),
                  Constants.regularBaseTextWidget(widget.unitText, 14)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
