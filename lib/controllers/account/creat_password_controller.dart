import 'package:code/controllers/account/password_page_controller.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../utils/string_util.dart';
import '../../utils/toast.dart';
import '../../widgets/account/cancel_button.dart';
import '../../widgets/account/custom_textfield.dart';

class CreatPassWordController extends StatefulWidget {
  const CreatPassWordController({super.key});

  @override
  State<CreatPassWordController> createState() =>
      _CreatPassWordControllerState();
}

class _CreatPassWordControllerState extends State<CreatPassWordController> {
  String _inputText = '';
  String _repeatInputText = '';
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _repeatController = TextEditingController();

  double textWidth = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                Constants.regularWhiteTextWidget("Creat a  password", 22),
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
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(132, 132, 132, 1.0),
                        fontFamily: 'SemiBold',
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    controller: _controller,
                    onTap: (text) {
                      _inputText = _controller.text;
                    },
                    placeHolder:
                        '8 to 32 characters, including letters and numbers',
                  ),
                ),
                Container(
                  width: Constants.screenWidth(context),
                  margin: EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Constants.regularGreyTextWidget('Repeat Password', 14),
                    ],
                  ),
                ),
                Container(
                  height: 66,
                  margin: EdgeInsets.only(left: 16, right: 18, top: 9),
                  child: CustomTextField(
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(132, 132, 132, 1.0),
                        fontFamily: 'SemiBold',
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    controller: _repeatController,
                    onTap: (text) {
                      _repeatInputText = _repeatController.text;
                    },
                    placeHolder:
                        '8 to 32 characters, including letters and numbers',
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    bool isvalidPwd = StringUtil.isValidPassword(_inputText);
                    bool pwdEqualToRepeatPwd = (_inputText == _repeatInputText);
                    if (!isvalidPwd) {
                      TTToast.showErrorInfo('Please enter a valid password');
                      return;
                    }
                    if (!pwdEqualToRepeatPwd) {
                      TTToast.showErrorInfo(
                          'The passwords entered twice are inconsistent, please check');
                      return;
                    }
                    NavigatorUtil.present(PasswordPageController(
                      password: _inputText,
                    ));
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
