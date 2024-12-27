import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';
class AddAndSubView extends StatefulWidget {
  final String title;
  const AddAndSubView({super.key,required this.title});

  @override
  State<AddAndSubView> createState() => _AddAndSubViewState();
}

class _AddAndSubViewState extends State<AddAndSubView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Constants.mediumWhiteTextWidget(widget.title, 16),
        SizedBox(height: 6,),
        Container(
          width: 260,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: hexStringToColor('#39394B'),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 24,right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(image: AssetImage('images/razor/add.png'),width: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Constants.mediumWhiteTextWidget('60', 23),
                    SizedBox(width: 2,),
                    Constants.mediumWhiteTextWidget('s', 16),
                  ],
                ),
                Image(image: AssetImage('images/razor/add.png'),width: 20,),

              ],
            ),
          ),

        ),
      ],
    );
  }
}
