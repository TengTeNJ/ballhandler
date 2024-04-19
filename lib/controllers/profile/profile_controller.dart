import 'package:code/constants/constants.dart';
import 'package:code/controllers/profile/integral_controller.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/route/route.dart';
import 'package:code/services/http/profile.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/views/profile/profile_grid_list_view.dart';
import 'package:code/views/profile/progress_data_view.dart';
import 'package:code/views/profile/reward_icons_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends StatefulWidget {
  const ProfileController({super.key});

  @override
  State<ProfileController> createState() => _ProfileControllerState();
}

class _ProfileControllerState extends State<ProfileController> {
  late MyAccountDataModel _model = MyAccountDataModel();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryMyAccountInfoData();
  }

  queryMyAccountInfoData() async{
    final _response = await Profile.queryIMyAccountInfoData();
    if(_response.success && _response.data != null){
      _model = _response.data!;
      setState(() {

      });
    }

  }
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
                   GestureDetector(
                     onTap: (){
                       NavigatorUtil.push(Routes.setting);
                     },
                     child:  Image(
                       image: AssetImage('images/profile/setting.png'),
                       width: 25,
                       height: 25,
                     ),
                   )
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async{
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: userModel.avatar.length > 0
                            ? Image.network(
                          userModel.avatar,
                          width: 64,
                          height: 64,
                        )
                            : Container(
                          width: 54,
                          height: 54,
                          color: hexStringToColor('#AA9155'),
                        ),
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
                SizedBox(height: 32,),
                GestureDetector(
                  onTap: (){
                    NavigatorUtil.present(IntegralController(model: _model,));
                  },
                  child: ProgressDataView(model: _model,),
                ),
                SizedBox(height: 40,),
                Constants.mediumWhiteTextWidget('Lifetime Stats', 16),
                SizedBox(height: 12,),
                ProfileGridListView(model: _model,),
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
