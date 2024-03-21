import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';
class RecordSelectView extends StatefulWidget {
  const RecordSelectView({super.key});

  @override
  State<RecordSelectView> createState() => _RecordSelectViewState();
}

class _RecordSelectViewState extends State<RecordSelectView> {
  bool _selectStatu = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          _selectStatu = !_selectStatu;
        });
        print('select---');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: hexStringToColor('#7A829B'),
              ),
              borderRadius: BorderRadius.circular(9),
              color:  _selectStatu == true ? Constants.baseStyleColor :  Color.fromRGBO(59, 74, 119, 1.0),
            ),
          ),
          SizedBox(width: 6,),
          Constants.regularWhiteTextWidget(' Recording', 14),
        ],
      ),
    );
  }
}
