import 'dart:io';

import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/base/user_header_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoView extends StatefulWidget {
  bool hasLogin;
  Function? subscribeTap;

  UserInfoView({this.subscribeTap, this.hasLogin = false});

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
              UserHeaderView(
                size: 54,
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<UserModel>(builder: (context, user, child) {
                    return Text('Hello, ' + user.userName + '!',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontFamily: 'SanFranciscoDisplay',
                            fontWeight: FontWeight.w500));
                  }),
                  widget.hasLogin &&
                      UserProvider.of(context).subscribeModel.subscribeStatus != 1 ? GestureDetector(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('images/participants/subscribe.png'),
                          width: 12,
                          height: 16,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Constants.regularGreyTextWidget(
                            'Subscribe Membership', 14,height: 1.3),
                        SizedBox(
                          width: 12,
                        ),
                        Image(
                          image: AssetImage('images/base/arrow.png'),
                          width: 5,
                          height: 10,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      if (widget.subscribeTap != null) {
                        widget.subscribeTap!();
                      }
                    },
                  ) : Constants.regularGreyTextWidget(
                      'Welcome to Potent Hockey DangleElite',  Platform.isIOS ? 14 : 13),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }
}
