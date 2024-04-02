import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/profile/integral_detail_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

class IntegralDetailController extends StatefulWidget {
  const IntegralDetailController({super.key});

  @override
  State<IntegralDetailController> createState() =>
      _IntegralDetailControllerState();
}

class _IntegralDetailControllerState extends State<IntegralDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(
        showBack: true,
        title: 'Points Details ',
      ),
      body: Column(children:[
        Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return IntegralView();
              },
              separatorBuilder: (context, index) => Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(color: hexStringToColor('#565674')),
                height: 1,
              ),
              itemCount: 20),
        )
      ] ,),
    );
  }
}
