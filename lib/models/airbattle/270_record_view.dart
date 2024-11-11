import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';
class ErQilingRecordSelectView extends StatefulWidget {
  Function? onTap;
  ErQilingRecordSelectView({this.onTap});

  @override
  State<ErQilingRecordSelectView> createState() => _ErQilingRecordSelectViewState();
}

class _ErQilingRecordSelectViewState extends State<ErQilingRecordSelectView> {
  bool _selectStatu = false;
  bool _canRecord = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if(!UserProvider.of(context).hasLogin || (UserProvider.of(context).hasLogin && UserProvider.of(context).subscribeModel.subscribeStatus !=1)){
    //   // 未登录 或者非订阅用户 是不支持录制视频的
    //  setState(() {
    //    _canRecord = false;
    //  });
    // }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          _selectStatu = !_selectStatu;
          if(widget.onTap != null){
            widget.onTap!(_selectStatu);
          }
        });
      },
      child: Column(
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
              // color:  _selectStatu == true ? hexStringToColor('#5BCC6A') :  Constants.baseGreyStyleColor,
              color:  !_canRecord ? Constants.baseGreyStyleColor : _selectStatu == true ? hexStringToColor('#5BCC6A') :  Color.fromRGBO(59, 74, 119, 1.0),
            ),
          ),
          SizedBox(width: 6,),
          Constants.regularWhiteTextWidget('Recording', 14),
        ],
      ),
    );
  }
}
