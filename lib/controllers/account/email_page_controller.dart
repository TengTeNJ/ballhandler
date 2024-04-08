import 'package:code/controllers/account/password_login_controller.dart';
import 'package:code/controllers/account/password_page_controller.dart';
import 'package:code/services/http/account.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/utils/toast.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../widgets/account/cancel_button.dart';

class EmailPageController extends StatefulWidget {
  const EmailPageController({super.key});

  @override
  State<EmailPageController> createState() => _EmailPageControllerState();
}

class _EmailPageControllerState extends State<EmailPageController> {
  String _inputText = '';
  final TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    // 在这里处理文本变化，比如打印出来
    _inputText =_controller.text;
  }

  void _handleInputFieldTap(int fieldNumber) {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: Constants.screenHeight(context)*0.95,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  SizedBox(
                    height: 10,
                  ),
                  Constants.regularWhiteTextWidget("Let's start with email", 22),
                  Container(
                    width: Constants.screenWidth(context),
                    margin: EdgeInsets.only(left: 16, right: 16, top: 55),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Constants.regularGreyTextWidget('Email', 14),
                      ],
                    ),
                  ),
                  Container(
                    height: 66,
                    margin: EdgeInsets.only(left: 16,right: 18,top: 9),
                    child:  TextField(
                      onTap: () => _handleInputFieldTap(1),
                      focusNode: _focusNode,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Constants.baseStyleColor), // 设置字体颜色
                      controller: _controller,
                      decoration: InputDecoration(
                        filled:true,
                        fillColor: Color.fromRGBO(28, 30, 33, 1.0),
                        hintText: 'Please Enter Your Email ', // 占位符文本
                        hintStyle: TextStyle(color: Colors.grey[400]), // 占位符颜色
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none, // 移除边框
                            borderRadius: BorderRadius.circular(10)), // 输入框边框样式
                      ) /**/,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async{
                      bool isvalidEmail = StringUtil.isValidEmail(_inputText);
                      if(isvalidEmail == false){
                        TTToast.showErrorInfo('Please enter a valid email');
                        return;
                      }
                      final canRegister = await Account.checkeEmail(_inputText);
                      // 跳转到输入密码页面
                      NSUserDefault.setKeyValue<String>(kInputEmail, _inputText);
                      if(canRegister.data == true){
                        NavigatorUtil.present(PasswordPageController());
                      }else{
                        NavigatorUtil.present(PassWordLoginController());
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
                ],
              ),
            ),),
        ),));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
