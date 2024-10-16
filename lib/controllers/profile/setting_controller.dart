import 'package:code/constants/constants.dart';
import 'package:code/controllers/account/set_email_controller.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/route/route.dart';
import 'package:code/services/http/account.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/utils/system_device.dart';
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
  String _version = '1.0';
  DateTime selectedDate = DateTime.now();


  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      // barrierColor: hexStringToColor('#3E3E55'),
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
            StringUtil.dateTimeToString(selectedDate);
        NSUserDefault.setKeyValue(
            kBrithDay, StringUtil.dateTimeToString(selectedDate));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApplicationVersion();
  }
  getApplicationVersion() async{
    _version = await SystemUtil.getApplicationVersion();
    setState(() {

    });
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
                  showArrows:  ISEmpty(UserProvider.of(context).email) ?  [true, true, true] : [true, false, true],
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
                    }else if(index == 1){
                       if(ISEmpty(UserProvider.of(context).email)){
                         NavigatorUtil.present(SetEmailController());
                       }
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
                  showArrows: [true],
                  title: 'Data',
                  datas: ['Video'],
                  detailTitles: [''],
                  selectItem: (index) {
                    if(index == 0){
                      NavigatorUtil.push(Routes.videolist);
                    }
                  }),
              SizedBox(
                height: 32,
              ),
              SettingView(
                showArrows: [true,false],
                title: 'More',
                detailTitles: ['','(内部测试)${_version}'],
                datas: ['Terms of Service','Version'],
                selectItem: (index) {
                if (index == 0){
                    NavigatorUtil.push(Routes.webview);
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
