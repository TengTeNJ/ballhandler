import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';
class RazorModeView extends StatelessWidget {
  final String imageName;
  const RazorModeView({super.key,required this.imageName});

  @override
  Widget build(BuildContext context) {
    final _size = (Constants.screenWidth(context) - 24*2 - 6*2) / 3.0;
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: hexStringToColor('#292936'),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: ISEmpty(imageName) ? Container() : Image(image: AssetImage('images/razor/mode/${imageName}.png'),),
      ),
    );
  }
}
