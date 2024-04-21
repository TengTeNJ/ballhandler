import 'package:code/constants/constants.dart';
import 'package:code/views/airbattle/message_list_view.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

import '../../services/http/airbattle.dart';

class MessageController extends StatefulWidget {
  const MessageController({super.key});
  @override
  State<MessageController> createState() => _MessageControllerState();
}

class _MessageControllerState extends State<MessageController> {
  List<MessageModel>_datas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  queryMessageDataList() async{
    final _response =  await AirBattle.queryAllMessageListData(1);
    if(_response.success && _response.data!=null){
      _datas.addAll(_response.data!);
      setState(() {

      });
    }else{
      _datas = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: true,
      ),
      backgroundColor: Constants.darkThemeColor,
      body: _datas.length == 0 ? NoDataView() : Container(
        margin: EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Constants.boldWhiteTextWidget('Notifications', 30),
            SizedBox(
              height: 30,
            ),
            Expanded(child: MessageListView(datas: _datas,)),
          ],
        ),
      ),
    );
  }
}

