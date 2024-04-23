import 'package:code/constants/constants.dart';
import 'package:code/services/http/profile.dart';
import 'package:code/utils/color.dart';
import 'package:code/widgets/base/base_image.dart';
import 'package:flutter/material.dart';

class ExchangeRewardsView extends StatefulWidget {
  ExchangeGoodModel model;

  ExchangeRewardsView({required this.model});

  @override
  State<ExchangeRewardsView> createState() => _ExchangeRewardsViewState();
}

class _ExchangeRewardsViewState extends State<ExchangeRewardsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 83,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: hexStringToColor('#292936')),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TTNetImage(
            url: widget.model.goodsImage,
            placeHolderPath: 'images/base/five.png',
            width: 113,
            height: 113,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
          ),
          SizedBox(
            width: 32,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Constants.regularGreyTextWidget(widget.model.goodsName, 14),
              // Constants.regularGreyTextWidget('Amazon ${widget.model.exchangeMoney}\$ Coupons', 14),
              SizedBox(
                height: 8,
              ),
              Constants.regularBaseTextWidget(
                  '${widget.model.goodsIntegral} Points', 14),
            ],
          ),
        ],
      ),
    );
  }
}
