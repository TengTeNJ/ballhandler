import 'package:code/constants/constants.dart';
import 'package:code/services/http/rank.dart';
import 'package:flutter/material.dart';

import '../../widgets/base/base_image.dart';

class AirbattleRankView extends StatefulWidget {
  RankModel model;
  AirbattleRankView({super.key,required this.model});

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
                url: widget.model.avatar ?? '',
                placeHolderPath: '',
                width: 38,
                height: 38,
                borderRadius: BorderRadius.circular(19),
              ),
              SizedBox(width: 12,),
              Constants.mediumWhiteTextWidget(widget.model.nickName ?? '', 20),
              SizedBox(width: 8,),
              Constants.regularGreyTextWidget(widget.model.country ?? '', 10),

            ],
          ),
          Row(
            children: [
              Constants.boldWhiteTextWidget(widget.model.avgPace ?? '', 24),
              SizedBox(width: 24,),
            ],
          )
        ],

      ),
    );
  }
}
