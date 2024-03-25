import 'package:code/constants/constants.dart';
import 'package:code/views/airbattle/message_list_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

class MessageController extends StatefulWidget {
  const MessageController({super.key});

  @override
  State<MessageController> createState() => _MessageControllerState();
}

class _MessageControllerState extends State<MessageController> {
  List _datas = [1];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: true,
      ),
      backgroundColor: Constants.darkThemeColor,
      body: _datas.length == 0 ? NoMessageWidget() : Container(
        margin: EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Constants.boldWhiteTextWidget('Notifications', 30),
            SizedBox(
              height: 30,
            ),
            Expanded(child: MessageListView()),
          ],
        ),
      ),
    );
  }
}

Widget NoMessageWidget() {
  return Center(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('images/airbattle/message_null.png'),
            width: 54,
            height: 64,
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'Nothing to see ..yet',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Rubik-Medium',
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}
