import 'package:code/constants/constants.dart';
import 'package:code/services/http/participants.dart';
import 'package:flutter/material.dart';

class RankingCardView extends StatefulWidget {
  int index = 0;
  RankingCardView({ required this.index});

  @override
  State<RankingCardView> createState() => _RankingCardViewState();
}

class _RankingCardViewState extends State<RankingCardView> {
String _avgPace = '-';
String _rankNumber = '-';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryData();
  }

  queryData() async{
    final _response = await Participants.queryRankData(widget.index + 1);
    if(_response.success && _response.data != null){
      _avgPace = _response.data!.avgPace ?? '-';
      _rankNumber = _response.data!.rankNumber ?? '-';
      setState(() {

      });
    }
  }

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
                  Constants.mediumWhiteTextWidget(_avgPace == '0' ? '-' : _avgPace, 40,height: 0.8),
                 Constants.regularWhiteTextWidget('sec/pt', 14,height: 1.0)
               ],),),
                SizedBox(height: 6,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Constants.customTextWidget('Best React Time', 14, '#B1B1B1'),
                  Row(
                    children: [
                      Image(image: AssetImage('images/ranking/rank.png'),width: 12,height: 15,),
                      SizedBox(width: 4,),
                      Constants.regularWhiteTextWidget('Rank ' + (_rankNumber == '0' ? '-' : _rankNumber), 14),
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
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
