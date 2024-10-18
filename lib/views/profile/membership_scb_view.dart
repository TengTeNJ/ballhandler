import 'package:code/utils/dialog.dart';
import 'package:flutter/material.dart';

import '../../route/route.dart';
import '../../utils/color.dart';
import '../../utils/navigator_util.dart';
class MemberShipScbView extends StatefulWidget {
  const MemberShipScbView({super.key});

  @override
  State<MemberShipScbView> createState() => _MemberShipScbViewState();
}

class _MemberShipScbViewState extends State<MemberShipScbView> {
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        NavigatorUtil.push(Routes.subscribe);
        //TTDialog.subscribeDialog(context);
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          SizedBox(height: 18,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/participants/subscribe.png'),
                width: 20,
                height: 25,
              ),
              SizedBox(width: 10,),
              Text(
                'Membership Subscription',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    // 添加下划线
                    decorationColor: hexStringToColor('#FFFFFF'),
                    // 下划线颜色
                    decorationThickness: 2,
                    // 下划线厚度
                    fontFamily: 'SanFranciscoDisplay',
                    color: hexStringToColor('#FFFFFF'),
                    fontSize: 16),
              )
            ],
          ),
          SizedBox(height: 18,),
        ],
      ),
    );
  }
}
