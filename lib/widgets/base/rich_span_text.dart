import 'package:flutter/material.dart';
class RichSpanText extends StatelessWidget {
  String text;
  String filterText;
  Color filterTextColor;
   RichSpanText({required this.text, required this.filterText,required this.filterTextColor});

  @override
  Widget build(BuildContext context) {
    // 使用TextSpan来构建富文本
    TextSpan textSpan = TextSpan(
      children: text.split(' ')
          .map((word) {
        // 检查单词是否应该被高亮
        if (word == filterText) {
          return WidgetSpan(
            child: FittedBox(
              child: Text(word, style: TextStyle(color:filterTextColor)),
            ),
          );
        } else {
          return TextSpan(text: word + ' ');
        }
      })
          .toList(),
    );
    return Text.rich(textSpan);
  }
}
