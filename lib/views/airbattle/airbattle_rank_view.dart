import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

import '../../widgets/base/base_image.dart';

class AirbattleRankView extends StatefulWidget {
  const AirbattleRankView({super.key});

  @override
  State<AirbattleRankView> createState() => _AirbattleRankViewState();
}

class _AirbattleRankViewState extends State<AirbattleRankView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) - 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 26,),
              Constants.boldWhiteTextWidget('1', 20),
              SizedBox(width: 12,),
              TTNetImage(
                url: '',
                placeHolderPath: '',
                width: 38,
                height: 38,
              ),
              SizedBox(width: 12,),
              Constants.mediumWhiteTextWidget('Mike', 20),
              SizedBox(width: 8,),
              Constants.regularGreyTextWidget('Canda', 10),

            ],
          ),
          Row(
            children: [
              Constants.boldWhiteTextWidget('0.3', 24),
              SizedBox(width: 24,),
            ],
          )
        ],

      ),
    );
  }
}
