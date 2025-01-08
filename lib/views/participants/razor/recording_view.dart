import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class RecordingView extends StatefulWidget {
  Function? onChange;
  bool? value;

  RecordingView({super.key, this.value, this.onChange});

  @override
  State<RecordingView> createState() => _RecordingViewState();
}

class _RecordingViewState extends State<RecordingView> {
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
      width: Constants.screenWidth(context) - 32,
      height: 101,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: hexStringToColor('#292936'),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image(
                image: AssetImage('images/razor/recording.png'),
                height: 20,
              ),
              SizedBox(
                width: 14,
              ),
              Constants.mediumWhiteTextWidget('Recording', 16),
            ],
          ),
          Row(
            children: [
              _value == false
                  ? Constants.mediumGreyTextWidget('OFF', 16)
                  : Constants.mediumWhiteTextWidget('ON', 16),
              SizedBox(
                width: 14,
              ),
              Switch(
                  activeTrackColor:hexStringToColor('#14B2B8'),
                  value: _value!, onChanged: (onChanged){
                setState(() {
                  _value = onChanged;
                  if(widget.onChange != null){
                    widget.onChange!(_value);
                  }
                });
              })
            ],
          ),
        ],
      ),
    );
  }
}
