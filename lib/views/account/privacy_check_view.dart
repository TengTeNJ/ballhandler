import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class PrivacyCheckView extends StatefulWidget {
  const PrivacyCheckView({super.key});

  @override
  State<PrivacyCheckView> createState() => _PrivacyCheckViewState();
}

class _PrivacyCheckViewState extends State<PrivacyCheckView> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
            fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey; // 禁用时的颜色
                }else if(states.contains(MaterialState.selected)){
                  return Constants.baseStyleColor;
                }
                return hexStringToColor('#1C1E21'); // 未选中时的颜色
              },
            ),
            checkColor: hexStringToColor('#1C1E21'),
            activeColor: Constants.baseStyleColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            // 设置为shrinkWrap来减小Checkbox的大小
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            }),
        SizedBox(
          width: 2,
        ),
        RichText(
          text: TextSpan(
            text: 'TBy signing up you agree to  Privacy Policy',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'SanFranciscoDisplay',
                fontSize: 12,
                fontWeight: FontWeight.w400),
            children: <TextSpan>[
              TextSpan(
                text: ' Privacy Policy',
                style: TextStyle(
                  fontFamily: 'SanFranciscoDisplay',
                  fontSize: 12,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
