import 'package:code/constants/constants.dart';
import 'package:code/route/route.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:code/views/profile/setting_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

import '../../utils/color.dart';

class SettingController extends StatefulWidget {
  const SettingController({super.key});

  @override
  State<SettingController> createState() => _SettingControllerState();
}

class _SettingControllerState extends State<SettingController> {
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: selectedDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: true,
      ),
      backgroundColor: Constants.darkThemeColor,
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:20,),
            Constants.boldWhiteTextWidget('Settings', 30),
            SizedBox(height:32,),
            SettingView(title: 'Edit Profile', datas: ['Username','Email','Birthday'],selectItem: (index){
              if(index ==0){
                TTDialog.userNameDialog(context);
              }else if(index == 2){
                _selectDate(context);
              }
            },),
            SizedBox(height:32,),
            SettingView(title: 'Date', datas: ['Video','Contact']),
            SizedBox(height:32,),
            SettingView(title: 'Privacy', datas: ['Private Profile','Activity Feed Privacy'],selectItem: (index){
              if(index == 0){
                NavigatorUtil.push(Routes.subsetting,arguments: {
                  "title" : "Private Prpfile",
                  "subTitle": "When your profile is Private,only membersyou approve can see your profile and workout history",
                });
              }else{
                NavigatorUtil.push(Routes.subsetting,arguments: {
                  "title" : "Argument",
                });
              }
            },),
            SizedBox(height:32,),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (){
                NSUserDefault.clearUserInfo(context);
                NavigatorUtil.pop();
              },child: Column(
              children: [
                Container(color: hexStringToColor('#707070'),height: 0.5,),
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Constants.regularGreyTextWidget('Logout', 16),
                    Image(
                      image: AssetImage('images/airbattle/next_white.png'),
                      width: 12,
                      height: 12,
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Container(color: hexStringToColor('#707070'),height: 0.5,),
              ],
            ),),
          ],
        ),),
      ),
    );
  }
}
