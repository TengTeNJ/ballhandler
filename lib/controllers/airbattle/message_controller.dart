import 'package:code/constants/constants.dart';
import 'package:code/views/airbattle/message_list_view.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';
import '../../services/http/airbattle.dart';
import '../../utils/toast.dart';

class MessageController extends StatefulWidget {
  const MessageController({super.key});
  @override
  State<MessageController> createState() => _MessageControllerState();
}

class _MessageControllerState extends State<MessageController> {
  List<MessageModel>_datas = [];
  int _page = 1;
  bool _hasMode = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryMessageDataList();
  }

  queryMessageDataList({bool loadMore = false}) async{
    if(loadMore){
      TTToast.showLoading();
    }else{
      _datas.clear();
    }
    final _response =  await AirBattle.queryAllMessageListData(_page);
    if(_response.success && _response.data!=null){
      _datas.addAll(_response.data!.datas!);
      _hasMode = (_datas.length < _response.data!.count);
      setState(() {

      });
    }else{
      _datas = [];
    }
    if(loadMore){
      TTToast.hideLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: true,
      ),
      backgroundColor: Constants.darkThemeColor,
      body:  Container(
        margin: EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Constants.boldWhiteTextWidget('Notifications', 30),
            SizedBox(
              height:   _datas.length == 0 ? 0 : 30,
            ),
              Expanded(child:   _datas.length == 0 ? NoDataView() : MessageListView(datas: _datas,loadMore: (){
                // 上拉加载
                print('下拉加载更多');
                if(_hasMode){
                  _page ++;
                  queryMessageDataList(loadMore: true);
                }
              })),
          ],
        ),
      ),
    );
  }
}

