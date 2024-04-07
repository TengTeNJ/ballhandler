import 'dart:convert';

import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../utils/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class MyStatsGridView extends StatefulWidget {
  const MyStatsGridView({super.key});

  @override
  State<MyStatsGridView> createState() => _MyStatsGridViewState();
}

class _MyStatsGridViewState extends State<MyStatsGridView> {

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(' Constants.screenHeight(context)=${ Constants.screenHeight(context)}');
    print(' Constants.screenWidtht(context)=${ Constants.screenWidth(context)}');

    return ScreenUtilInit(
      designSize: const Size(375, 848),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:(context,child){
        return Container(
          height: 136,
          width: (Constants.screenWidth(context) - 8 - 32) / 2.0,
          decoration: BoxDecoration(
              color: hexStringToColor('#3E3E55'),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(baseMargin(context, 10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Constants.regularGreyTextWidget('Best React Time', kFontSize(context, 12)),
                    Image(
                      image: AssetImage('images/profile/time.png'),
                      width: 20,
                      height: 16,
                    )
                  ],
                ),),
              Container(
                margin: EdgeInsets.only(left: baseMargin(context, 12),right: baseMargin(context, 10),bottom: baseMargin(context, 16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '0.6',
                          style: TextStyle(
                              fontSize: kFontSize(context, 40), color: Colors.white, height: 0.8,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Sec',
                          style: TextStyle(
                              fontSize: kFontSize(context, 10), color: Colors.white, height: 0.8),
                        )
                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('VS. Last Week',style: TextStyle(color: hexStringToColor('#B1B1B1'),fontSize: kFontSize(context, 12)),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Constants.customTextWidget('+2.5%', kFontSize(context, 12), '#5BCC6A'),
                            SizedBox(width: 1,),
                            Icon(
                              size: 12,
                              Icons.arrow_upward,
                              color: hexStringToColor('#5BCC6A'),
                            )
                          ],
                        ),

                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      } ,
    );
  }
}
