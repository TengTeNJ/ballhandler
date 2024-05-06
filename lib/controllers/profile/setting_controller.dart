import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/route/route.dart';
import 'package:code/services/http/account.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/views/profile/setting_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/color.dart';
import '../../utils/notification_bloc.dart';

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
      final _response = await Account.updateAccountInfo(
          {"birthday": StringUtil.dateTimeToString(selectedDate)});
      if (_response.success) {
        UserProvider.of(context).brith =
            StringUtil.dateToBrithString(selectedDate);
        NSUserDefault.setKeyValue(
            kBrithDay, StringUtil.dateToBrithString(selectedDate));
      }
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Constants.boldWhiteTextWidget('Settings', 30),
              SizedBox(
                height: 32,
              ),
              Consumer<UserModel>(builder: (context, userModel, child) {
                return SettingView(
                  showArrows: [true, false, true],
                  title: 'Edit Profile',
                  datas: ['Username', 'Email', 'Birthday'],
                  detailTitles: [
                    userModel.userName,
                    userModel.email,
                    StringUtil.serviceStringToShowDateString(userModel.brith)
                  ],
                  selectItem: (index) {
                    if (index == 0) {
                      // 修改昵称
                      TTDialog.userNameDialog(context, (value) async {
                        final _response = await Account.updateAccountInfo(
                            {"nickName": value});
                        if (_response.success) {
                          UserProvider.of(context).userName = value;
                          NSUserDefault.setKeyValue(kUserName, value);
                        }
                      });
                    } else if (index == 2) {
                      // 修改生日
                      print('userModel.brith=${userModel.brith}');
                      if (userModel.brith.length < 4) {
                        selectedDate = DateTime.now();
                      } else {
                        selectedDate = StringUtil.stringToDate(userModel.brith);
                      }
                      _selectDate(context);
                    }
                  },
                );
              }),
              SizedBox(
                height: 32,
              ),
              SettingView(
                  showArrows: [true, true],
                  title: 'Date',
                  datas: ['Video', 'Contact'],
                  detailTitles: ['', ''],
                  selectItem: (index) {
                    if(index == 0){
                      NavigatorUtil.push(Routes.videolist);
                    }
                  }),
              SizedBox(
                height: 32,
              ),
              SettingView(
                showArrows: [true, true],
                title: 'Privacy',
                detailTitles: ['', ''],
                datas: ['Private Profile', 'Activity Feed Privacy'],
                selectItem: (index) {
                  if (index == 0) {
                    NavigatorUtil.push(Routes.subsetting, arguments: {
                      "title": "Private Prpfile",
                      "subTitle":
                          "When your profile is Private,only membersyou approve can see your profile and workout history",
                    });
                  } else {
                    NavigatorUtil.push(Routes.subsetting, arguments: {
                      "title": "Argument",
                    });
                  }
                },
              ),
              SizedBox(
                height: 32,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  NSUserDefault.clearUserInfo(context);
                  EventBus().sendEvent(kSignOut);
                  NavigatorUtil.pop();
                },
                child: Column(
                  children: [
                    Container(
                      color: hexStringToColor('#707070'),
                      height: 0.5,
                    ),
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
                    Container(
                      color: hexStringToColor('#707070'),
                      height: 0.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
