import 'package:code/constants/constants.dart';
import 'package:code/models/mystats/my_stats_model.dart';
import 'package:code/views/airbattle/my_stats_bar_chart_view.dart';
import 'package:code/views/airbattle/my_stats_grid_list_view.dart';
import 'package:code/views/airbattle/my_stats_line_area_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MyStatsController extends StatefulWidget {
  const MyStatsController({super.key});

  @override
  State<MyStatsController> createState() => _MyStatsControllerState();
}

class _MyStatsControllerState extends State<MyStatsController> {
  List<MyStatsModel> datas = [];
  num temp = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < 20; i++) {
      var random = Random();
      int randomNumber = random.nextInt(11);
      MyStatsModel model = MyStatsModel();
      model.speed = randomNumber / 10 + 1;
      model.indexString = (i + 1).toString();
      datas.add(model);
      temp = temp < model.speed ? model.speed : temp;
    }
    print('temp=${temp}');
    print('temp/0.2=${temp / 0.2}');
    print('temp/0.2.ceil()*36=${(temp / 0.2).ceil() * 36}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(
        showBack: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Constants.boldWhiteTextWidget('My Stats', kFontSize(context, 30)),
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image(
                        image:
                            AssetImage('images/participants/icon_orange.png'),
                        width: 32,
                        height: 32,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Constants.mediumWhiteTextWidget(
                          'Training Model', kFontSize(context, 16)),
                    ],
                  ),
                  Row(
                    children: [
                      Image(
                        image: AssetImage('images/participants/rank.png'),
                        width: 12,
                        height: 16,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Constants.mediumWhiteTextWidget(
                          'RANK  40', kFontSize(context, 16)),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
              MyStatsGridListView(), // grid view
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Constants.regularWhiteTextWidget(
                      'Training Growth', kFontSize(context, 14)),
                ],
              ),
              SizedBox(
                height: 36,
              ),
              Container(
                height: (temp / 0.2).ceil() * 36 + 36,
                child: LineAreaView(datas),
              ),
              SizedBox(
                height: 40,
              ),
              Constants.regularWhiteTextWidget(
                  'Best In History', kFontSize(context, 14)),
              SizedBox(
                height: 36,
              ),
              Container(
                height: (temp / 0.2).ceil() * 36 + 36,
                child: BarView( datas),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget LineAreaView(List<MyStatsModel> datas) {
  int page = 1;
  if (datas.length > 30) {
    page = (datas.length / 30).ceil();
  }
  return PageView.builder(
    itemBuilder: (context, index) {
      return MyStatsLineAreaView(
          datas: datas.sublist(
              index * 10,
              (index + 1) * 30 > datas.length
                  ? datas.length
                  : (index + 1) * 30));
    },
    itemCount: page,
  );
}

Widget BarView(List<MyStatsModel> datas) {
  int page = 1;
  if (datas.length >10) {
    page = 2;
  }
  return PageView.builder(
    itemBuilder: (context, index) {
      return MyStatsBarChatView(
          datas: datas.sublist(index * 10,
              page > 1 ? (index == 0 ? 10 : datas.length) : datas.length));
    },
    itemCount: page,
  );
}
