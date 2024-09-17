import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoView extends StatefulWidget {
  bool hasLogin;
  Function?subscribeTap;
   UserInfoView({this.subscribeTap,this.hasLogin = false});

  @override
  State<UserInfoView> createState() => _UserInfoViewState();
}

class _UserInfoViewState extends State<UserInfoView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, userModel, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(27),
                child: userModel.avatar.length > 0
                    ? Image.network(
                        userModel.avatar,
                        width: 54,
                        height: 54,
                        fit: BoxFit.fill,
                      )
                    : Container(
                        width: 54,
                        height: 54,
                        color: hexStringToColor('#AA9155'),
                      ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<UserModel>(builder: (context, user, child) {
                    return Text( 'Hello, ' +user.userName + '!',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontFamily: 'SanFranciscoDisplay',
                            fontWeight: FontWeight.w500));
                  }),
                  Constants.regularGreyTextWidget('Welcome to Potent Hockey DangleElite', 12)
                ],
              ),
            ],
          ),
          widget.hasLogin  && UserProvider.of(context).subscribeModel.subscribeStatus != 1 ? GestureDetector(
            child: Image(
              image: AssetImage('images/participants/subscribe.png'),
              width: 20,
              height: 25,
            ),
            behavior: HitTestBehavior.opaque,
            onTap: () {
              print('订阅弹窗');
              if(widget.subscribeTap != null){
                widget.subscribeTap!();
              }
            },
          ) : Container()
        ],
      );
    });
  }
}
