import 'package:code/services/http/account.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/utils/toast.dart';
import 'package:code/widgets/account/custom_textfield.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../utils/navigator_util.dart';
import '../../widgets/account/cancel_button.dart';
import 'package:country_picker/country_picker.dart';

class PasswordPageController extends StatefulWidget {
  String? password;

  PasswordPageController({this.password});

  @override
  State<PasswordPageController> createState() => _PasswordPageControllerState();
}

class _PasswordPageControllerState extends State<PasswordPageController> {
  final TextEditingController _nameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _nameText = '';
  DateTime selectedDate = DateTime.now();
  String _countryText = '';

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
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      }
    }
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: GestureDetector(
            onTap: () {
             FocusScope.of(context).unfocus();
            },
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
                  Constants.regularWhiteTextWidget("Choose your Profile", 22),
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
                        child: Constants.regularGreyTextWidget('From', 14,
                            textAlign: TextAlign.left),
                      ),
                      GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus(); // 移除焦点
                          showCountryPicker(
                            context: context,
                            showPhoneCode: false,
                            // optional. Shows phone code before the country name.
                            onSelect: (Country country) {
                              _countryText = country.name;
                              //FocusScope.of(context).unfocus();
                              setState(() {});
                            },
                          );
                        },
                        child: Container(
                          height: 66,
                          width: Constants.screenWidth(context) - 32,
                          margin: EdgeInsets.only(
                              left: 16, right: 18, top: 9, bottom: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(28, 30, 33, 1.0)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            //   Image(image: AssetImage('images/account/down.png'))
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _countryText,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Constants.baseStyleColor,
                                      fontSize: 16,
                                      height: 1.0),
                                ),
                                Image(
                                  image: AssetImage('images/account/down.png'),
                                  width: 14,
                                  height: 8,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16),
                        child: Constants.regularGreyTextWidget(
                            'Date of birth', 14,
                            textAlign: TextAlign.left),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('_selectDate _selectDate');
                          _selectDate(context);
                        },
                        child: Container(
                          height: 66,
                          width: Constants.screenWidth(context) - 32,
                          margin: EdgeInsets.only(
                              left: 16, right: 18, top: 9, bottom: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(28, 30, 33, 1.0)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            //   Image(image: AssetImage('images/account/down.png'))
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  StringUtil.dateTimeToString(selectedDate),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Constants.baseStyleColor,
                                      fontSize: 16,
                                      height: 1.0),
                                ),
                                Image(
                                  image: AssetImage('images/account/down.png'),
                                  width: 14,
                                  height: 8,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      bool isvalidName = StringUtil.isValidNickname(_nameText);
                      if (isvalidName == false) {
                        TTToast.showErrorInfo('Please enter a legal nickname,1 to 32 characters, including letters and numbers',duration: 5000);
                        return;
                      }
                      if (isvalidName == true) {
                        ApiResponse _response = await Account.registerWithEmail(
                            widget.password ?? '',
                            StringUtil.dateTimeToString(selectedDate),
                            _nameText,
                            _countryText);
                        if (_response.success == true) {
                          final _response =
                              await Account.emailLogin(widget.password ?? '');
                          if (_response.success == true) {
                            Account.handleUserData(_response, context);
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
          ),
        ));
  }
}
