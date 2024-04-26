import 'package:code/controllers/account/send_email_controller.dart';
import 'package:code/services/http/account.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../utils/navigator_util.dart';
import '../../widgets/account/cancel_button.dart';
import '../../widgets/account/custom_textfield.dart';

class PassWordLoginController extends StatefulWidget {
  const PassWordLoginController({super.key});

  @override
  State<PassWordLoginController> createState() =>
      _PassWordLoginControllerState();
}

class _PassWordLoginControllerState extends State<PassWordLoginController> {
  String _inputText = '';
  final TextEditingController _controller = TextEditingController();
  double textWidth = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.darkControllerColor,
        body: SingleChildScrollView(
          // controller: _scrollController,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Constants.darkControllerColor,
              ),
              height: Constants.screenHeight(context) * 0.95,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  SizedBox(
                    height: 10,
                  ),
                  Constants.regularWhiteTextWidget("Welcome back", 22),
                  Container(
                    width: Constants.screenWidth(context),
                    margin: EdgeInsets.only(left: 16, right: 16, top: 55),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Constants.regularGreyTextWidget('Password', 14),
                      ],
                    ),
                  ),
                  Container(
                    height: 66,
                    margin: EdgeInsets.only(left: 16, right: 18, top: 9),
                    child: CustomTextField(
                      obscureText:true,
                      controller: _controller,
                      onTap: (text) {
                        _inputText = text;
                      },
                      placeHolder: 'Please Enter Your Password',
                    ),
                  ),
                  GestureDetector(
                    onTap: () async{
                     final _response = await Account.emailLogin(_inputText);
                     // 登录成功
                     if(_response.success == true){
                       Account.handleUserData(_response, context);
                       NavigatorUtil.popToRoot();
                     }
                    },
                    child: Container(
                      child: Center(
                        child: Constants.mediumWhiteTextWidget('Continue', 16),
                      ),
                      height: 56,
                      margin: EdgeInsets.only(left: 16, right: 16, top: 32),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Constants.baseStyleColor),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(top: 24),
                      child: Center(
                        child: Text(
                          'Forgot password',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'SanFranciscoDisplay',
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            // 设置下划线
                            decorationColor: Colors.white,
                            // 设置下划线颜色为红色
                            decorationThickness: 2.0, // 设置下划线粗细为2.0
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      NavigatorUtil.present(SendEmailController());
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
