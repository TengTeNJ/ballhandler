import 'package:code/models/global/user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/color.dart';

class UserHeaderView extends StatefulWidget {
  double size;

  UserHeaderView({this.size = 54});

  @override
  State<UserHeaderView> createState() => _UserHeaderViewState();
}

class _UserHeaderViewState extends State<UserHeaderView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, userModel, child) {
      return Container(
        width: widget.size,
        height: widget.size,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: userModel.avatar.length > 0
                  ? Image.network(
                      userModel.avatar,
                      fit: BoxFit.fill,
                    )
                  : Container(
                      width: widget.size,
                      height: widget.size,
                      color: hexStringToColor('#AA9155'),
                    ),
            ),
            Positioned(
                right: 0,
                bottom: 0,
                child: UserProvider.of(context).hasLogin &&
                        UserProvider.of(context)
                                .subscribeModel
                                .subscribeStatus ==
                            1
                    ? Image(
                        image: AssetImage('images/profile/vip.png'),
                        width: 16,
                        height: 16,
                        fit: BoxFit.fill,
                      )
                    : Container())
          ],
        ),
      );
    });
  }
}
