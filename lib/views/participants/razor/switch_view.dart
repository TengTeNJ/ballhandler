import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';
class SwitchView extends StatefulWidget {
  final String title;
  Function? onChange;
  bool? value;
  SwitchView({super.key,required this.title,this.value,this.onChange});

  @override
  State<SwitchView> createState() => _SwitchViewState();
}

class _SwitchViewState extends State<SwitchView> {
  bool _value = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _value = widget.value ?? false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12,right: 12),
      decoration: BoxDecoration(
        color: hexStringToColor('#292936'),
        borderRadius: BorderRadius.circular(5),
      ),
      width: (Constants.screenWidth(context) - 32 - 6) / 2.0,
      height: 101,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 12,),
          Row(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: AssetImage('images/razor/random.png'),width: 22,),
              SizedBox(width: 12,),
              Constants.mediumWhiteTextWidget(widget.title,16),
            ],
          ),
          SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Constants.mediumWhiteTextWidget('ON', 16),
              Switch(
                  activeTrackColor:hexStringToColor('#14B2B8'),
                  value: _value, onChanged: (onChanged){
                    setState(() {
                      _value = onChanged;
                      if(widget.onChange != null){
                        widget.onChange!(_value);
                      }
                    });
              })
            ],
          )
        ],
      ),
    );
  }
}
