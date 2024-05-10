import 'package:code/services/http/airbattle.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/airbattle/message_view.dart';
import 'package:flutter/material.dart';

class MessageListView extends StatefulWidget {
   List<MessageModel>datas;
   Function? loadMore;
   MessageListView({required this.datas,this.loadMore});

  @override
  State<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      print('上拉加载---');
      if(widget.loadMore != null){
        widget.loadMore!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        controller: _scrollController,
        itemBuilder: (context, index) {
          if(index == widget.datas.length){
            return Container();
          }else{
            return MessageView(model: widget.datas[index],);
          }
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 0.5,
            decoration: BoxDecoration(
                color: hexStringToColor('#565674'),
                borderRadius: BorderRadius.circular(1)),
          );
        },
        itemCount: widget.datas.length + 1);
  }
}
