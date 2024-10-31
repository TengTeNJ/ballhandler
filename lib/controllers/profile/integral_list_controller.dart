import 'package:code/constants/constants.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

import '../../views/profile/exchange_rewards_list_view.dart';

class IntegralListController extends StatefulWidget {
  int integralMinLevel = 0;
  int integralMaxLevel = 2000;
  int userIntegral = 0; // 用户的积分

  IntegralListController(
      {this.integralMinLevel = 0,
      this.integralMaxLevel = 2000,
      this.userIntegral = 0});

  @override
  State<IntegralListController> createState() => _IntegralListControllerState();
}

class _IntegralListControllerState extends State<IntegralListController> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(
        'widget.integralMinLevel = ${widget.integralMinLevel} widget.integralMaxLevel = ${widget.integralMaxLevel}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Container(
          width: Constants.screenWidth(context),
          color: Constants.darkControllerColor,
          child: Column(
            children: [
              Container(
                width: Constants.screenWidth(context),
                height: 82,
                child: Stack(
                  children: [
                    Positioned(
                        left: 16,
                        top: 26,
                        // bottom: 26,
                        child: Container(
                          width: 30,
                          height: 30,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              // 点击返回按钮时的操作
                              Navigator.of(context).pop();
                            },
                            color: Colors.white,
                            iconSize: 30, // 设置图标大小
                          ),
                        )),
                    Center(
                      child:
                          Constants.boldWhiteTextWidget('Exchange Rewards', 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                  child: ExchangeRewardListView(
                userIntegral: widget.userIntegral,
                integralMaxLevel: widget.integralMaxLevel,
                integralMinLevel: widget.integralMinLevel,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
