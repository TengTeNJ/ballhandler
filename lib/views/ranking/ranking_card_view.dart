import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

class RankingCardView extends StatefulWidget {
  const RankingCardView({super.key});

  @override
  State<RankingCardView> createState() => _RankingCardViewState();
}

class _RankingCardViewState extends State<RankingCardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: Constants.screenWidth(context) ,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/ranking/ranking_card.png'),
              fit: BoxFit.fill)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 16,right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Constants.mediumWhiteTextWidget(
                      'Digital stickhandling trainer', 14,
                      textAlign: TextAlign.left),
                ),
                Image(
                  image: AssetImage('images/ranking/next.png'),
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16,right: 16),
            child: Column(
              children: [
               Container(child:  Row(crossAxisAlignment: CrossAxisAlignment.end,children: [
                  Constants.mediumWhiteTextWidget('0.7', 40,height: 0.8),
                 Constants.regularWhiteTextWidget('sec/pt', 14,height: 1.0)
               ],),),
                SizedBox(height: 6,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Constants.customTextWidget('Best React Time', 14, '#B1B1B1'),
                  Row(
                    children: [
                      Image(image: AssetImage('images/ranking/rank.png'),width: 12,height: 15,),
                      SizedBox(width: 4,),
                      Constants.regularWhiteTextWidget('Rank 40', 14),
                    ],
                  ),
                ],),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
