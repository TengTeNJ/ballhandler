import 'package:code/controllers/account/password_login_controller.dart';
import 'package:code/widgets/account/custom_textfield.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../utils/navigator_util.dart';
import '../../widgets/account/cancel_button.dart';

class PasswordPageController extends StatefulWidget {
  const PasswordPageController({super.key});

  @override
  State<PasswordPageController> createState() => _PasswordPageControllerState();
}

class _PasswordPageControllerState extends State<PasswordPageController> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _againPwdController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  void _handleInputFieldTap(int fieldNumber) {
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.addListener(() {

    });
    _pwdController.addListener(() {

    });
    _againPwdController.addListener(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            height: Constants.screenHeight(context),
            decoration: BoxDecoration(
                color: Constants.darkControllerColor,
                borderRadius: BorderRadius.circular(26)),
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
                Constants.regularWhiteTextWidget("Creat a ID and password", 22),
                SizedBox(
                  height: 48,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Constants.regularGreyTextWidget('Name', 14,textAlign: TextAlign.left),
                    ),
                    Container(
                      height: 66,
                      margin: EdgeInsets.only(left: 16, right: 18, top: 9,bottom: 20),
                      child: CustomTextField(
                        controller: _nameController,
                        placeHolder: 'Please Enter Your Name',
                        onTap: () => _handleInputFieldTap(1),
                      ),
                    ),
                    Container(
                      width: Constants.screenWidth(context) - 32,
                      margin: EdgeInsets.only(left: 16),
                      child: Constants.regularGreyTextWidget('Password', 14,textAlign: TextAlign.left),
                    ),
                    Container(
                      height: 66,
                      margin: EdgeInsets.only(left: 16, right: 18, top: 9,bottom: 20),
                      child: CustomTextField(
                        obscureText: true,
                        controller: _pwdController,
                        keyboardType: TextInputType.visiblePassword,
                        placeHolder: 'Please Enter Your Password',
                        onTap: () => _handleInputFieldTap(2),
                      ),
                    ),
                    Container(
                      width: Constants.screenWidth(context) - 32,
                      margin: EdgeInsets.only(left: 16),
                      child: Constants.regularGreyTextWidget(
                          'Repeat Password', 14,textAlign: TextAlign.left),
                    ),
                    Container(
                      height: 66,
                      margin: EdgeInsets.only(left: 16, right: 18, top: 9),
                      child: CustomTextField(
                        obscureText: true,
                        controller: _againPwdController,
                        keyboardType: TextInputType.visiblePassword,
                        placeHolder: 'Please Enter Your Password',
                        onTap: () => _handleInputFieldTap(3),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    NavigatorUtil.present(PassWordLoginController());
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
        ));
  }
}
