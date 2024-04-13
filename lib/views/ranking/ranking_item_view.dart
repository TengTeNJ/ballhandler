import 'package:code/constants/constants.dart';
import 'package:code/services/http/rank.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class RankingItemView extends StatefulWidget {
  RankModel model;
   RankingItemView({required this.model});

  @override
  State<RankingItemView> createState() => _RankingItemViewState();
}

class _RankingItemViewState extends State<RankingItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: hexStringToColor('#3E3E55'),
          borderRadius: BorderRadius.circular(10)),
      height: 72,
      child: Stack(
        children: [
          widget.model.trainVideo.length > 0 ? Positioned(
              top: 8,
              right: 8,
              child: Container(
                  width: 32,
                  height: 14,
                  decoration: BoxDecoration(
                      color: Constants.baseStyleColor,
                      borderRadius: BorderRadius.circular(3)),
                  child:  Center(child:  Constants.regularWhiteTextWidget('View', 10))
              )) : Container() ,
          Positioned(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                Constants.boldWhiteTextWidget(widget.model.rankNumber.toString(), 20),
                SizedBox(width: 16,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: ISEmpty(widget.model.avatar)? Container(
                    width: 38,
                    height: 38,
                    color: hexStringToColor('#AA9155'),
                  ):Image.network(
                    widget.model.avatar.toString(),
                    width: 38,
                    height: 38,
                  ),
                ),
                SizedBox(width: 8,),
                Constants.mediumWhiteTextWidget(widget.model.nickName.toString().length > 7 ? widget.model.nickName.toString().substring(0,6):widget.model.nickName.toString(), 20),
                SizedBox(width: 8,),
                Constants.regularGreyTextWidget(widget.model.country.toString(), 10),
              ],),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                 // Text('0.9',style: TextStyle(fontSize: 20,height: 1.0,color: Colors.white),),
                  Constants.boldWhiteTextWidget(widget.model.avgPace.toString(), 20,height: 0.8),
                  SizedBox(width: 8,),
                  Constants.regularWhiteTextWidget('sec/pt', 10)],
              ),
            ],
          ),left: 24,right: 24,top: 16,bottom: 16,),
        ],
      ),
    );
  }
}
