import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

class CareerItemView extends StatefulWidget {
  bool? unlocked;

  num? score;

  CareerItemView({super.key, this.unlocked = false, this.score = 500});

  @override
  State<CareerItemView> createState() => _CareerItemViewState();
}

class _CareerItemViewState extends State<CareerItemView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          image: AssetImage(widget.unlocked == true
              ? 'images/stats/unlocked.png'
              : 'images/stats/locked.png'),
          width: 102,
          height: 102,
        ),
        const SizedBox(width: 32,),
        Constants.regularWhiteTextWidget('${widget.score} pts', 24)
      ],
    );
  }
}
