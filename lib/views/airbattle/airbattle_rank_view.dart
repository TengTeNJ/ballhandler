import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/services/http/rank.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

import '../../widgets/base/base_image.dart';

class AirbattleRankView extends StatefulWidget {
  int rank;
  RankModel model;
  AirbattleRankView({super.key,required this.model,required this.rank});

  @override
  State<AirbattleRankView> createState() => _AirbattleRankViewState();
}

class _AirbattleRankViewState extends State<AirbattleRankView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) - 32,
      color:    widget.model.memberId == UserProvider.of(context).userId ? hexStringToColor('#B6C5F6') : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 26,),
              Constants.boldWhiteTextWidget('1', 20),
              SizedBox(width: 12,),
               [1,2,3].contains(widget.rank) ? Container(
                width: 48,
                height: 48,
                //color: Colors.green,
                child: Stack(
                  children: [
                    Image(image: AssetImage('images/airbattle/rank${widget.rank}.png'),fit: BoxFit.fill,),
                    Positioned(
                        left: 5,
                        right: 5,
                        bottom: 8,
                        child: TTNetImage(
                          url: widget.model.avatar ?? '',
                          placeHolderPath: '',
                          width: 38,
                          height: 38,
                          borderRadius: BorderRadius.circular(19),
                        )),
                  ],
                ),
              ) : TTNetImage(
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
