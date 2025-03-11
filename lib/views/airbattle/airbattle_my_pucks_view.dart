import 'package:code/constants/constants.dart';
import 'package:code/models/airbattle/my_pucks_model.dart';
import 'package:flutter/material.dart';

class AirbattleMyPucksView extends StatefulWidget {
  MyPucksModel model;

  AirbattleMyPucksView({super.key, required this.model});

  @override
  State<AirbattleMyPucksView> createState() => _AirbattleMyPucksViewState();
}

class _AirbattleMyPucksViewState extends State<AirbattleMyPucksView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Image(
              image: AssetImage(widget.model.inageName),
              height: 60,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(
              width: 32,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Constants.regularGreyTextWidget(widget.model.title, 16),
                SizedBox(height: 12,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Constants.regularWhiteTextWidget(widget.model.value, 40,height: 0.8,),
                    SizedBox(width: 4,),
                    Constants.regularWhiteTextWidget(widget.model.unit, 14),
                  ],
                ),
                SizedBox(height: 12,),
                widget.model.specialShow
                    ? Constants.regularBaseTextWidget(widget.model.des, 14)
                    : Constants.regularGreyTextWidget(widget.model.des, 14)
              ],
            )
          ],
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
