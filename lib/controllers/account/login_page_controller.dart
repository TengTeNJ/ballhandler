import 'package:code/constants/constants.dart';
import 'package:code/controllers/account/email_page_controller.dart';
import 'package:code/controllers/account/privacy_page_controller.dart';
import 'package:code/controllers/account/set_user_info_controller.dart';
import 'package:code/models/http/user_model.dart';
import 'package:code/services/http/account.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/login_util.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/notification_bloc.dart';
import 'package:code/utils/toast.dart';
import 'package:code/views/account/privacy_check_view.dart';
import 'package:code/widgets/account/cancel_button.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class LoginPageController extends StatefulWidget {
  const LoginPageController({super.key});

  @override
  State<LoginPageController> createState() => _LoginPageControllerState();
}

class _LoginPageControllerState extends State<LoginPageController> with SingleTickerProviderStateMixin{
  bool privacyChecked = false;
  //  第三方登录图标和图片
  final List<Map> _thirdMaps = [
    {'icon': 'images/account/apple.png', 'label': 'Continue with Apple'},
    {'icon': 'images/account/google.png', 'label': 'Continue with Google'},
    {'icon': 'images/account/facebook.png', 'label': 'Continue with FaceBook'},
  ];

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // 在email页面弹出键盘时总是会弹出溢出的错误，以为是那个页面除了错误，最终发现原来是这个页面的Column溢出了，也是点击控制台日志发现的，于是使用这个方式解决
        backgroundColor: Colors.transparent,
        body: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Container(
            width:Constants.screenWidth(context),
            color: Constants.darkControllerColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 36,
                  margin: EdgeInsets.only(right: 16, top: 16),
                  child: Stack(
                    children: [
                      Positioned(
                        child: CancelButton(),
                        right: 0,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 68,
                  width: 117,
                  child: Image(
                    image: AssetImage('images/account/potent.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: 230,
                  height: 32,
                  margin: EdgeInsets.only(top: 15),
                  child: Center(
                    child:
                        Constants.boldWhiteTextWidget('sign up or log in', 22),
                  ),
                ),
                Container(
                    width: 300,
                    height: 32,
                    margin: EdgeInsets.only(top: 0),
                    child: Center(
                      child: Constants.boldWhiteTextWidget(
                          ' to access your profile', 22),
                    )),
                Container(
                  // color: Colors.red,
                  margin: EdgeInsets.only(top: 48),
                  child: Column(
                    children: List.generate(_thirdMaps.length, (index) {
                      return InkWell(
                        onTap: () async {
                          if(!privacyChecked){
                            TTToast.showToast('Please check the privacy policy first');
                            Vibration.vibrate(duration: 500); // 触发震动
                            return;
                          }
                          LoginType type = LoginType.values[index];
                          ApiResponse<User> _response =
                              await LoginUtil.thirdLogin(type);
                          print('result=${_response.success}');
                          if (_response.success == true) {
                            // 登录成功
                            Account.handleUserData(_response, context);
                            final _checkResponse = await Account.checkeSetUserInfoStatu();
                            if(_checkResponse.data == false){
                              // 跳转到设置用户信息页面
                              NavigatorUtil.pop();
                              NavigatorUtil.present(SetUserInfoController());
                            }else{
                              NavigatorUtil.pop();
                              EventBus().sendEvent(kLoginSucess);
                            }
                          };
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 13),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(28, 30, 33, 1.0),
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(left: 16, right: 16),
                            height: 56,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Constants.regularWhiteTextWidget(
                                      _thirdMaps[index]['label'], 14),
                                ),
                                Positioned(
                                    left: 12,
                                    top: 16,
                                    child: Image(
                                      width: 20,
                                      height: 24,
                                      image:
                                          AssetImage(_thirdMaps[index]['icon']),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 1,
                        color: Color.fromRGBO(177, 177, 177, 1.0),
                        width: (Constants.screenWidth(context) - 32 - 24) / 2.0,
                      ),
                      Center(
                        child:Constants.regularGreyTextWidget('or', 14),
                      ),
                      Container(
                        height: 1,
                        color: Color.fromRGBO(177, 177, 177, 1.0),
                        width: (Constants.screenWidth(context) - 32 - 24) / 2.0,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(privacyChecked){
                      NavigatorUtil.present(EmailPageController());
                    }else{
                      if(!privacyChecked){
                        TTToast.showToast('Please check the privacy policy first');
                        Vibration.vibrate(duration: 500); // 触发震动
                        return;
                      }
                    }
                  },
                  child: Container(
                    height: 56,
                    margin: EdgeInsets.only(top: 22, left: 16, right: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Constants.baseStyleColor),
                    child: Center(
                      child: Constants.regularWhiteTextWidget(
                          'Continue with email', 16),
                    ),
                  ),
                ),
                SizedBox(height: 16,),
                PrivacyCheckView(onSelected: (value){
                  privacyChecked = value;
                },goToPrivacy: (){
                  NavigatorUtil.present(PrivacyPageController());
                },),
              ],
            ),
          ),
        ));
  }
}
