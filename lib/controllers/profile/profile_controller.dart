import 'package:code/constants/constants.dart';
import 'package:code/controllers/profile/integral_controller.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/views/profile/profile_grid_list_view.dart';
import 'package:code/views/profile/profile_grid_view.dart';
import 'package:code/views/profile/progress_data_view.dart';
import 'package:code/views/profile/reward_icons_view.dart';
import 'package:code/views/profile/reward_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileController extends StatefulWidget {
  const ProfileController({super.key});

  @override
  State<ProfileController> createState() => _ProfileControllerState();
}

class _ProfileControllerState extends State<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 24, right: 24),
          child: Consumer<UserModel>(builder: (context,userModel,child){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image(
                      image: AssetImage('images/profile/setting.png'),
                      width: 25,
                      height: 25,
                    )
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: userModel.avatar.length > 0
                          ? Image.network(
                        userModel.avatar,
                        width: 64,
                        height: 64,
                      )
                          : Image(
                        image: AssetImage('images/participants/icon_orange.png'),
                        width: 54,
                        height: 54,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12,),
                Constants.boldWhiteTextWidget(userModel.userName, 22,textAlign: TextAlign.left,),
                SizedBox(height: 12,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Constants.customTextWidget('Candan', 16,'#B1B1B1'),
                    SizedBox(width: 18,),
                    Container(height: 10,width: 1,color: hexStringToColor('#707070'),),
                    SizedBox(width: 18,),
                    Constants.customTextWidget('July 4, 2024', 16,'#B1B1B1'),
                  ],
                ),
                RewardView(),
                SizedBox(height: 6,),
                GestureDetector(
                  onTap: (){
                    NavigatorUtil.present(IntegralController());
                  },
                  child: ProgressDataView(),
                ),
                SizedBox(height: 40,),
                Constants.mediumWhiteTextWidget('Lifetime Stats', 16),
                SizedBox(height: 12,),
                ProfileGridListView(),
                SizedBox(height: 40,),
                Constants.mediumWhiteTextWidget('Pending discussion', 16),
                SizedBox(height: 12,),
                RewardiconsView(),
              ],
            );
          },),
        ),
      ),
    );
  }
}
