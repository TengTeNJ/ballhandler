import 'package:flutter/material.dart';
import 'package:avoid_keyboard/avoid_keyboard.dart';

import '../../constants/constants.dart';
import '../../widgets/account/cancel_button.dart';
class PasswordPageController extends StatefulWidget {
  const PasswordPageController({super.key});

  @override
  State<PasswordPageController> createState() => _PasswordPageControllerState();
}

class _PasswordPageControllerState extends State<PasswordPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: Constants.darkControllerColor ,
              borderRadius: BorderRadius.circular(26)),
          child:Column(
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
              TextField(),
            ],
          ),
        ));
  }
}
