import 'package:code/services/http/account.dart';
import 'package:code/services/http/participants.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:code/widgets/account/cancel_button.dart';
import 'package:code/widgets/account/custom_textfield.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class SendEmailController extends StatefulWidget {
  const SendEmailController({super.key});

  @override
  State<SendEmailController> createState() => _SendEmailControllerState();
}

class _SendEmailControllerState extends State<SendEmailController> {
  String _email = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInputEmailText();
  }

  getInputEmailText() async{
   final _text = await  NSUserDefault.getValue<String>(kInputEmail);
  _email = _text ?? '';
  setState(() {
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            // 键盘下落
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: Constants.screenHeight(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              // color: Colors.red
              color: Constants.darkControllerColor,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16, right: 16),
                  height: 36,
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
                  margin: EdgeInsets.only(top: 57),
                  child: Constants.mediumWhiteTextWidget(
                      'Forgot your password?', 20),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Constants.regularGreyTextWidget(
                      'Enter your email to get help logging in.', 16),
                ),
                Container(
                  width: Constants.screenWidth(context) - 48,
                  margin: EdgeInsets.only(top: 75, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Constants.regularGreyTextWidget('Email', 14),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: 56,
                          child: CustomTextField(
                            controller: _controller,
                            onTap: (text){
                              _email = text;
                            },
                            placeHolder: _email,
                          )),
                      GestureDetector(
                        onTap: () async{
                        final _response =  await Account.sendFogetPwdEmail(_email);
                        if(_response.success){}
                        TTDialog.sendEmailDialog(context,(){
                          Future.delayed(Duration(milliseconds: 100),(){
                            NavigatorUtil.pop();
                          });
                        });
                        print('发送邮件成功');
                        },
                        child: Container(
                          child: Center(
                            child: Constants.mediumWhiteTextWidget(
                                'Send email', 16),
                          ),
                          height: 56,
                          margin: EdgeInsets.only(left: 0, right: 0, top: 32),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Constants.baseStyleColor),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
