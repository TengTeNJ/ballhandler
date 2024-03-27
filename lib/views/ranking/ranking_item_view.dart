import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class RankingItemView extends StatefulWidget {
  const RankingItemView({super.key});

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
          Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 32,
                height: 14,
                decoration: BoxDecoration(
                    color: Constants.baseStyleColor,
                    borderRadius: BorderRadius.circular(3)),
                child:  Center(child:  Constants.regularWhiteTextWidget('View', 10))
              )),
          Positioned(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                Constants.boldWhiteTextWidget('1', 20),
                SizedBox(width: 16,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: Image.asset(
                    'images/bottom/ranking_selected.png',
                    width: 38,
                    height: 38,
                  ),
                ),
                SizedBox(width: 8,),
                Constants.mediumWhiteTextWidget('Mike', 20),
                SizedBox(width: 8,),
                Constants.regularGreyTextWidget('Canada', 10),
              ],),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Constants.boldWhiteTextWidget('0.9', 20,height: 0.8),
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
