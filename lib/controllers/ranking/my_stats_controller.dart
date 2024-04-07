import 'package:code/constants/constants.dart';
import 'package:code/views/airbattle/my_stats_grid_list_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

class MyStatsController extends StatefulWidget {
  const MyStatsController({super.key});

  @override
  State<MyStatsController> createState() => _MyStatsControllerState();
}

class _MyStatsControllerState extends State<MyStatsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(showBack: true,),
      body: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16,),
              Constants.boldWhiteTextWidget('My Stats', kFontSize(context, 30)),
              SizedBox(height: 32,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Image(image: AssetImage(
                        'images/participants/icon_orange.png'),
                        width: 32,
                        height: 32 ,),
                    SizedBox(width: 12,),
                    Constants.mediumWhiteTextWidget('Training Model', kFontSize(context, 16)),
                  ],),
                  Row(children: [
                    Image(image: AssetImage(
                        'images/participants/rank.png'),
                      width: 12,
                      height: 16 ,),
                    SizedBox(width: 12,),
                    Constants.mediumWhiteTextWidget('RANK  40', kFontSize(context, 16)),
                  ],)
                ],
              ),
              SizedBox(height: 24,),
              MyStatsGridListView(),// grid view
              SizedBox(height: 16,),
             Row(
               children: [
                 Constants.regularWhiteTextWidget('Training Growth', kFontSize(context, 14)),
               ],
             ),

            ],
          ),
        ),
      ),
    );
  }
}
