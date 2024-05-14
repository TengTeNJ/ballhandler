import 'package:code/constants/constants.dart';
import 'package:code/services/http/airbattle.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/message_ytil.dart';
import 'package:code/utils/notification_bloc.dart';
import 'package:flutter/material.dart';

// class MessageView extends StatelessWidget {
//   MessageModel model;
//
//   MessageView({required this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () async{
//         //await AirBattle.readMessage(mo)
//       },
//       child: Container(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 16,
//             ),
//             Row(
//               children: [
//                 Stack(
//                   children: [
//                     Image(
//                       image: AssetImage('images/airbattle/message_blue.png'),
//                       width: 48,
//                       height: 48,
//                     ),
//                     Positioned(
//                         top: 2,
//                         right: 6,
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(4)),
//                           width: 8,
//                           height: 8,
//                         ))
//                   ],
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 // 加了Expanded 可以自动换行 默认撑起高度
//                 Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Constants.mediumWhiteTextWidget(model.messageTitle, 14),
//                         SizedBox(
//                           height: 4,
//                         ),
//                         Text(
//                           // maxLines: 3,
//                           textAlign: TextAlign.left,
//                           model.messageDesc,
//                           style: TextStyle(
//                               color: hexStringToColor('#B1B1B1'), fontSize: 14),
//                         )
//                       ],
//                     )), // 这里使用Expanded 包着column 这样column的高度可以根据文本的高度撑起来,会换行
//               ],
//             ),
//             SizedBox(
//               height: 16,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class MessageView extends StatefulWidget {
  MessageModel model;
  MessageView({required this.model});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async{
        final _response = await AirBattle.readMessage(widget.model.pushId);
        if(_response.success){
          widget.model.isRead = 1;
          MessageUtil.readMessage(); // 更新角标信息
          EventBus().sendEvent(kMessageRead);
          setState(() {

          });
        }
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Stack(
                  children: [
                    Image(
                      image: AssetImage('images/airbattle/message_blue.png'),
                      width: 48,
                      height: 48,
                    ),
                    widget.model.isRead == 0 ?  Positioned(
                        top: 2,
                        right: 6,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4)),
                          width: 8,
                          height: 8,
                        )) :Container()
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                // 加了Expanded 可以自动换行 默认撑起高度
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Constants.mediumWhiteTextWidget(widget.model.messageTitle, 14),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          // maxLines: 3,
                          textAlign: TextAlign.left,
                          widget.model.messageDesc,
                          style: TextStyle(
                              color: hexStringToColor('#B1B1B1'), fontSize: 14),
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
      ),
    );
  }
}

