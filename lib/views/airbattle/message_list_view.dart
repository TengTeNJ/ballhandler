import 'package:code/utils/color.dart';
import 'package:code/views/airbattle/message_view.dart';
import 'package:flutter/material.dart';

class MessageListView extends StatefulWidget {
  const MessageListView({super.key});

  @override
  State<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return MessageView();
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 0.5,
            decoration: BoxDecoration(
                color: hexStringToColor('#565674'),
                borderRadius: BorderRadius.circular(1)),
          );
        },
        itemCount: 20);
  }
}
