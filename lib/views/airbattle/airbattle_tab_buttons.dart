import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class AirbattleTabButtons extends StatefulWidget {
  List<String> titles;
  Function? selectTab;
  AirbattleTabButtons({super.key, required this.titles,this.selectTab});

  @override
  State<AirbattleTabButtons> createState() => _AirbattleTabButtonsState();
}

class _AirbattleTabButtonsState extends State<AirbattleTabButtons> {
  int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      height: 38,
      width: Constants.screenWidth(context) - 32,
      decoration: BoxDecoration(
          color: hexStringToColor('#3E3E55'),
          borderRadius: BorderRadius.circular(26)),
      child: Row(
        children: List.generate(widget.titles.length, (index) {
          return Expanded(
              child: Container(
                height: 38,
            decoration: BoxDecoration(
                color: _selectIndex == index
                    ? Constants.baseStyleColor
                    : hexStringToColor('#3E3E55'),
                borderRadius: BorderRadius.circular(26)),
            child: Center(
              child: GestureDetector(
                child: Constants.regularWhiteTextWidget(widget.titles[index], 14),
                onTap: () {
                  setState(() {
                    _selectIndex = index;
                  });
                  if(widget.selectTab != null){
                    widget.selectTab!(index);
                  }
                },
              ),
            ),
          ));
        }),
      ),
    );
  }
}
