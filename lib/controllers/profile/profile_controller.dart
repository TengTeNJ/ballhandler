import 'dart:async';

import 'package:code/constants/constants.dart';
import 'package:code/controllers/profile/integral_controller.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/route/route.dart';
import 'package:code/services/http/account.dart';
import 'package:code/services/http/participants.dart';
import 'package:code/services/http/profile.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/views/profile/profile_grid_list_view.dart';
import 'package:code/views/profile/progress_data_view.dart';
import 'package:code/views/profile/reward_icons_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../utils/notification_bloc.dart';
import '../account/login_page_controller.dart';

class ProfileController extends StatefulWidget {
  const ProfileController({super.key});

  @override
  State<ProfileController> createState() => _ProfileControllerState();
}

class _ProfileControllerState extends State<ProfileController> {
  late MyAccountDataModel _model = MyAccountDataModel();
  late StreamSubscription subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryMyAccountInfoData();
    // 监听
    subscription = EventBus().stream.listen((event) {
      if (event == kSignOut) {
        //  退出登录
        _model.integral = 0;
        _model.upperLimit = 2000;
        _model.avgPace = 0;
        _model.trainScore = 0;
        _model.trainTime = 0;
        _model.trainCount = 0;
        if (mounted) {
          setState(() {});
        }
      }else if (event == kLoginSucess){
        queryMyAccountInfoData();
      }
    });
  }

  queryMyAccountInfoData() async {
    final _response = await Profile.queryIMyAccountInfoData();
    if (_response.success && _response.data != null) {
      _model = _response.data!;
      if(mounted){
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.baseControllerColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 24, right: 24),
          child: Consumer<UserModel>(
            builder: (context, userModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          final _hasLogin = UserProvider.of(context).hasLogin;
                          if (_hasLogin == false) {
                            NavigatorUtil.present(LoginPageController());
                            return;
                          }
                          NavigatorUtil.push(Routes.setting);
                        },
                        child: Image(
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
                        onTap: () async {
                          // 未登录的话拦截
                          final _hasLogin = UserProvider.of(context).hasLogin;
                          if (_hasLogin == false) {
                            NavigatorUtil.present(LoginPageController());
                            return;
                          }
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          final croppedFile = await ImageCropper().cropImage(
                            maxHeight: 64,
                            maxWidth: 64,
                            sourcePath:
                                pickedFile != null ? pickedFile!.path : '',
                            aspectRatioPresets: [
                              CropAspectRatioPreset.ratio3x2,
                              CropAspectRatioPreset.ratio4x3,
                              CropAspectRatioPreset.ratio16x9,
                              CropAspectRatioPreset.square,
                            ],
                            androidUiSettings: AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor: Colors.deepOrange,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                            iosUiSettings: IOSUiSettings(
                              title: 'Cropper',
                            ),
                          );
                          if (croppedFile != null) {
                            // 上传头像
                            final _response = await Participants.uploadAsset(
                                croppedFile!.path);
                            if (_response.success) {
                              final _updateResponse =
                                  await Account.updateAccountInfo(
                                      {"avatar": _response.data});
                              if (_updateResponse.success) {
                                UserProvider.of(context).avatar =
                                    _response.data ?? '';
                                NSUserDefault.setKeyValue(
                                    kAvatar, _response.data ?? '');
                              }
                            }
                          }
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
                  SizedBox(
                    height: 12,
                  ),
                  Constants.boldWhiteTextWidget(
                    userModel.userName,
                    22,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Constants.customTextWidget(
                          userModel.country, 16, '#B1B1B1'),
                      SizedBox(
                        width: 18,
                      ),
                      Container(
                        height: 10,
                        width: 1,
                        color: hexStringToColor('#707070'),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Constants.customTextWidget(
                              StringUtil.serviceStringToShowDateString(userModel.brith),
                          16,
                          '#B1B1B1'),
                    ],
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  GestureDetector(
                    onTap: () {
                      // 积分页面
                      // 未登录的话拦截
                      final _hasLogin = UserProvider.of(context).hasLogin;
                      if (_hasLogin == false) {
                        NavigatorUtil.present(LoginPageController());
                        return;
                      }
                      NavigatorUtil.present(IntegralController(
                        model: _model,
                      ));
                    },
                    child: ProgressDataView(
                      model: _model,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Constants.mediumWhiteTextWidget('Lifetime Stats', 16),
                  SizedBox(
                    height: 12,
                  ),
                  ProfileGridListView(
                    model: _model,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Constants.mediumWhiteTextWidget('Pending discussion', 16),
                  SizedBox(
                    height: 12,
                  ),
                  RewardiconsView(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }
}
