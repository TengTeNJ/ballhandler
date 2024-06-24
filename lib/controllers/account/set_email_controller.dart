import 'package:code/utils/navigator_util.dart';
import 'package:code/widgets/account/cancel_button.dart';
import 'package:code/widgets/account/custom_textfield.dart';
import 'package:code/widgets/base/base_button.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class SetEmailController extends StatelessWidget {
  const SetEmailController({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    String _inputText = '';
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          // color: Colors.red
          color: Constants.darkControllerColor,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          child: Column(
            children: [
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CancelButton(),
                ],
              ),
              SizedBox(height: 56,),
              Constants.mediumWhiteTextWidget('Please fill in your email', 20),
              SizedBox(height: 16,),
              Constants.regularWhiteTextWidget('We need to get your email to provide you with a better experience', 16),
              SizedBox(height: 56,),
              Row(
                children: [
                  Constants.regularGreyTextWidget('Email', 14),
                ],
              ),
              SizedBox(height: 10,),
              CustomTextField(
                hintStyle: TextStyle(
                    color: Color.fromRGBO(132, 132, 132, 1.0),
                    fontFamily: 'SanFranciscoDisplay',
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                keyboardType: TextInputType.visiblePassword,
                controller: _controller,
                onTap: (text) {
                  _inputText = _controller.text;
                },
                placeHolder:
                'Please Enter Your Email',
              ),
              SizedBox(height: 32,),
               BaseButton(title: 'Get Start',height: 56,onTap: (){
                 NavigatorUtil.pop();
               },)
            ],
          ),
        ),
      ),
    );
  }
}
