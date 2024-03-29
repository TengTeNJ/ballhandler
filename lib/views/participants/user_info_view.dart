import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoView extends StatefulWidget {
  const UserInfoView({super.key});

  @override
  State<UserInfoView> createState() => _UserInfoViewState();
}

class _UserInfoViewState extends State<UserInfoView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, userModel, child) {
      return Row(
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
                  )
                : Image(
                    image: AssetImage('images/participants/icon_orange.png'),
                    width: 54,
                    height: 54,
                  ),
          ),
          SizedBox(
            height: 4,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<UserModel>(builder: (context, user, child) {
                return Text(user.userName,
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontFamily: 'SanFranciscoDisplay',
                        fontWeight: FontWeight.w500));
              }),
              Text(
                'welcome to use  POTENT HOCKEY',
                style: TextStyle(
                    color: Constants.baseGreyStyleColor,
                    fontFamily: 'SanFranciscoDisplay',
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
        ],
      );
    });
  }
}
