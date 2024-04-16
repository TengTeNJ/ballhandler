import 'package:code/controllers/account/email_page_controller.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../widgets/account/cancel_button.dart';

class PrivacyPageController extends StatefulWidget {
  const PrivacyPageController({super.key});

  @override
  State<PrivacyPageController> createState() => _PrivacyPageControllerState();
}

class _PrivacyPageControllerState extends State<PrivacyPageController> {
  bool isChecked = false;
  final _onTap = (){
   NavigatorUtil.pop();
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Container(
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
                  width: Constants.screenWidth(context),
                  margin: EdgeInsets.only(left: 16, right: 16, top: 81),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Constants.boldBaseTextWidget('Your Privacy', 16),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        Constants.privacyText,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.5,
                          fontFamily: 'SanFranciscoDisplay',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _onTap ,
                  child: Container(
                    child: Center(
                      child: Constants.mediumWhiteTextWidget('Got it', 16),
                    ),
                    height: 56,
                    margin: EdgeInsets.only(left: 16, right: 16, top: 64),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:  Constants.baseStyleColor ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
