import 'package:code/constants/constants.dart';
import 'package:code/models/airbattle/p3_item_model.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/global.dart';

class P3ItemView extends StatefulWidget {
  P3ItemModel model = P3ItemModel();
  Function? selectItem;

  P3ItemView({required this.model,this.selectItem});

  @override
  State<P3ItemView> createState() => _P3ItemViewState();
}

class _P3ItemViewState extends State<P3ItemView> {
  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if( !widget.model.selected ){
          GameUtil gameUtil = GetIt.instance<GameUtil>();
          if(gameUtil.selectdP3Items.length >= 3){
            return;
          }
        }

        if(widget.selectItem != null){
          widget.model.selected = !widget.model.selected;
          widget.selectItem!(widget.model.index);
          setState(() {
            _selected = widget.model.selected;
          });
        }
      },
      child: Container(
        height: 185,
        width: (Constants.screenWidth(context) - 36) / 2.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: widget.model.selected
              ? hexStringToColor('#204DD1')
              : hexStringToColor('#292936'),
        ),
        child: Stack(
          children: [
            widget.model.selected
                ? Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            hexStringToColor('#B6F61D'),
                            hexStringToColor('#DBDB14'),
                          ],
                        ),
                      ),
                      child: Center(
                          child: Constants.customTextWidget(
                              widget.model.selectedIndex.toString(),
                              12,
                              '#204DD1')),
                    ))
                : Container(),
            Positioned(
                top: 35,
                left: 10,
                right: 10,
                child: Image(
                  image: AssetImage('images/p3/${widget.model.imagePath}.png'),
                  height: 60,
                  fit: BoxFit.fitHeight,
                )),
            Positioned(
                top: 111,
                left: 10,
                right: 10,
                child:
                    _selected ? Constants.mediumWhiteTextWidget(widget.model.title, 14) : Constants.mediumGreyTextWidget(widget.model.title, 14)),
            Positioned(
                top: 150,
                left: 10,
                right: 10,
                child: _selected ? Constants.mediumWhiteTextWidget(
                    widget.model.timeString, 14) : Constants.mediumGreyTextWidget(
                    widget.model.timeString, 14))
          ],
        ),
      ),
    );
  }
}
