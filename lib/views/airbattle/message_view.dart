import 'package:code/constants/constants.dart';
import 'package:code/services/http/airbattle.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class MessageView extends StatelessWidget {
  MessageModel model;
   MessageView({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Image(image: AssetImage('images/airbattle/message_blue.png'),width: 48,height: 48,),
              SizedBox(width: 20,),
              // 加了Expanded 可以自动换行 默认撑起高度
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Constants.mediumWhiteTextWidget(model.messageTitle, 14),
                  SizedBox(height: 4,),
                  Text(
                    // maxLines: 3,
                    textAlign: TextAlign.left,
                    model.messageDesc,
                    style: TextStyle(color: hexStringToColor('#B1B1B1'),fontSize: 14),
                  )
                ],
              )), // 这里使用Expanded 包着column 这样column的高度可以根据文本的高度撑起来,会换行
            ],
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
