import 'package:code/models/global/user_info.dart';
import 'package:code/models/http/user_model.dart';
import 'package:code/services/http/account.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/utils/toast.dart';
import 'package:code/widgets/account/custom_textfield.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../utils/navigator_util.dart';
import '../../widgets/account/cancel_button.dart';

class PasswordPageController extends StatefulWidget {
  const PasswordPageController({super.key});

  @override
  State<PasswordPageController> createState() => _PasswordPageControllerState();
}

class _PasswordPageControllerState extends State<PasswordPageController> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _againPwdController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _nameText = '';
  String _pwdText = '';
  String _repeatPwdText = '';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _selectDate(BuildContext context) async {
       DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: selectedDate,
      );
       print('picked=${picked}');

      if (picked != null && picked != selectedDate){
        setState(() {
          selectedDate = picked;
        });
      }

    }
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            height: Constants.screenHeight(context),
            decoration: BoxDecoration(
                color: Constants.darkControllerColor,
                borderRadius: BorderRadius.circular(26)),
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
                SizedBox(
                  height: 10,
                ),
                Constants.regularWhiteTextWidget("Creat a ID and password", 22),
                SizedBox(
                  height: 48,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Constants.regularGreyTextWidget('Name', 14,
                          textAlign: TextAlign.left),
                    ),
                    Container(
                      height: 66,
                      margin: EdgeInsets.only(
                          left: 16, right: 18, top: 9, bottom: 20),
                      child: CustomTextField(
                        controller: _nameController,
                        onTap: (text) {
                          _nameText = _nameController.text;
                        },
                        placeHolder: 'Please Enter Your Name',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Constants.regularGreyTextWidget(
                          'Date of birth', 14,
                          textAlign: TextAlign.left),
                    ),
                   GestureDetector(
                     onTap: (){
                       _selectDate(context);
                     },
                     child:  Container(
                       height: 66,
                       width: Constants.screenWidth(context) - 32,
                       margin: EdgeInsets.only(
                           left: 16, right: 18, top: 9, bottom: 20),
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           color: Color.fromRGBO(28, 30, 33, 1.0)),
                       child: Padding(
                         padding: EdgeInsets.only(left: 16, top: 25),
                         child: Text(
                           StringUtil.dateTimeToString(selectedDate),
                           textAlign: TextAlign.left,
                           style: TextStyle(
                               color: Constants.baseStyleColor,
                               fontSize: 16,
                               height: 1.0),
                         ),
                       ),
                     ),
                   ),
                    Container(
                      width: Constants.screenWidth(context) - 32,
                      margin: EdgeInsets.only(left: 16),
                      child: Constants.regularGreyTextWidget('Password', 14,
                          textAlign: TextAlign.left),
                    ),
                    Container(
                      height: 66,
                      margin: EdgeInsets.only(
                          left: 16, right: 18, top: 9, bottom: 20),
                      child: CustomTextField(
                        obscureText: true,
                        controller: _pwdController,
                        onTap: (text) {
                          _pwdText = _pwdController.text;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        placeHolder: 'Please Enter Your Password',
                      ),
                    ),
                    Container(
                      width: Constants.screenWidth(context) - 32,
                      margin: EdgeInsets.only(left: 16),
                      child: Constants.regularGreyTextWidget(
                          'Repeat Password', 14,
                          textAlign: TextAlign.left),
                    ),
                    Container(
                      height: 66,
                      margin: EdgeInsets.only(left: 16, right: 18, top: 9),
                      child: CustomTextField(
                        obscureText: true,
                        controller: _againPwdController,
                        onTap: (text) {
                          _repeatPwdText = _againPwdController.text;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        placeHolder: 'Please Enter Your Password',
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    bool isvalidName = StringUtil.isValidNickname(_nameText);
                    bool isvalidPwd = StringUtil.isValidPassword(_pwdText);
                    bool pwdEqualToRepeatPwd = _pwdText == _repeatPwdText;
                    print('_nameText=${_nameText}');
                    print('_pwdText=${_pwdText}');
                    print('_repeatPwdText=${_repeatPwdText}');

                    if (isvalidName == false) {
                      TTToast.showErrorInfo('Please enter a legal nickname');
                      return;
                    }
                    if (isvalidPwd == false) {
                      TTToast.showErrorInfo('Please enter a valid password');
                      return;
                    }
                    if (pwdEqualToRepeatPwd == false) {
                      TTToast.showErrorInfo(
                          'The passwords entered twice are inconsistent, please check');
                      return;
                    }
                    if (isvalidName == true &&
                        isvalidName == true &&
                        pwdEqualToRepeatPwd == true) {
                      ApiResponse _response = await Account.registerWithEmail(
                          _pwdText, StringUtil.dateTimeToString(selectedDate), _nameText);
                      if (_response.success == true) {
                        // NavigatorUtil.present()
                        final _response = await Account.emailLogin(_pwdText);
                        if (_response.success == true) {
                          handleUserData(_response, context);
                          NavigatorUtil.popToRoot();
                        }
                      }
                    }
                  },
                  child: Container(
                    child: Center(
                      child: Constants.mediumWhiteTextWidget('Continue', 16),
                    ),
                    height: 56,
                    margin: EdgeInsets.only(left: 16, right: 16, top: 32),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Constants.baseStyleColor),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

/*处理登录成功后返回的数据*/
handleUserData(ApiResponse<User> _response, BuildContext context) {
  NSUserDefault.setKeyValue<String>(kUserName, _response.data!.nickName);
  NSUserDefault.setKeyValue<String>(kAccessToken, _response.data!.memberToken);
  NSUserDefault.setKeyValue<String>(kAvatar, _response.data!.avatar);
  UserProvider.of(context).userName = _response.data!.nickName;
  UserProvider.of(context).token = _response.data!.memberToken;
  UserProvider.of(context).avatar = _response.data!.avatar;
  UserProvider.of(context).createTime = _response.data!.createTime;

}
