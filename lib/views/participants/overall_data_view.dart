import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverAllDataView extends StatefulWidget {
  const OverAllDataView({super.key});

  @override
  State<OverAllDataView> createState() => _OverAllDataViewState();
}

class _OverAllDataViewState extends State<OverAllDataView> {
  final List<String> _titles = ['MAX.pace','Total Score','Total Time','Total Times'];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(62, 62, 85, 1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Constants.regularGreyTextWidget('Career Statistics', 14),
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Constants.regularBaseTextWidget('Today', 12),
                      SizedBox(width: 6,),
                      Image(
                        image: AssetImage('images/participants/back.png'),
                        width: 5,
                        height: 9,
                      )
                    ],
                  ),
                ),
                onTap: (){
                  print('点击Today按钮');
                  NavigatorUtil.push('todayData');
                  UserProvider.of(context).totalScore = '9000';
                },
              )
            ],
          ),
          Consumer<UserModel>(builder: (context, user, child) {
            return Row(
              children: List.generate(user.overDataList.length, (index) {
                return Expanded(
                    child: Row(
                  children: [
                    Container(
                      width: (Constants.screenWidth(context) - 32 -2) /4.0,
                      // color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Constants.mediumWhiteTextWidget(user.overDataList[index], 20),
                          Constants.regularGreyTextWidget(_titles[index], 10),

                        ],
                      ),
                    ),
                    index != (user.overDataList.length-1) ? Container(
                      height: 30,
                      width: 0.5,
                      color: Color.fromRGBO(86, 86, 116, 1.0),
                    ):Container(),
                  ],
                ));
              }),
            );
          })
        ],
      ),
    );
  }
}
