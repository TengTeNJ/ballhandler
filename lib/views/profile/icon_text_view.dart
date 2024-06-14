import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

class IconTextView extends StatefulWidget {
  String? iconPath;
  String title;
  double? size;
  String? titleColor;

  IconTextView(
      {required this.title, this.iconPath, this.size, this.titleColor});

  @override
  State<IconTextView> createState() => _IconTextViewState();
}

class _IconTextViewState extends State<IconTextView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
            image: AssetImage(widget.iconPath != null
                ? widget.iconPath!
                : 'images/profile/dark_grey_icon.png'),
            width: widget.size != null ? widget.size! : 48,
            height: widget.size != null ? widget.size! : 48),
        SizedBox(height: 10,),
        Constants.customTextWidget(widget.title, 12,
            widget.titleColor != null ? widget.titleColor! : '#FFFFFF')
      ],
    );
  }
}
