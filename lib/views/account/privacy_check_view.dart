import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class PrivacyCheckView extends StatefulWidget {
  Function? onSelected;
  Function? goToPrivacy;
   PrivacyCheckView({this.onSelected,this.goToPrivacy});

  @override
  State<PrivacyCheckView> createState() => _PrivacyCheckViewState();
}

class _PrivacyCheckViewState extends State<PrivacyCheckView> with SingleTickerProviderStateMixin{
  bool isChecked = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller);
    _animation.addListener(() {
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedBuilder(animation: _animation, builder: (context,child){
          return Transform.scale(
            scale: isChecked ? 1.0 : _animation.value,
            child: Checkbox(
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
                checkColor: Colors.white,
                activeColor: Constants.baseStyleColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                // 设置为shrinkWrap来减小Checkbox的大小
                visualDensity: VisualDensity(horizontal: -2, vertical: -4),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                    if(!isChecked){
                      _controller.stop();
                    }else{
                      print('reset');
                      _controller.forward();
                        _controller.repeat(reverse: true);
                    }
                    if(widget.onSelected != null){
                      widget.onSelected!(isChecked);
                    }
                  });
                }),
          );
        }),
         GestureDetector(
           onTap: (){
             if(widget.goToPrivacy != null){
               widget.goToPrivacy!();
             }
           },
           child: RichText(
             text: TextSpan(
               text: 'By signing up you agree to  Privacy Policy',
               style: TextStyle(
                   color: Constants.baseGreyStyleColor,
                   fontFamily: 'SanFranciscoDisplay',
                   fontSize: 12,
                   height: 1.0,
                   fontWeight: FontWeight.w400),
               children: <TextSpan>[
                 TextSpan(
                   text: ' Privacy Policy',
                   style: TextStyle(
                     fontFamily: 'SanFranciscoDisplay',
                     fontSize: 12,
                     color: Colors.white,
                     height: 1.0,
                     fontWeight: FontWeight.w400,
                     decoration: TextDecoration.underline,
                   ),
                 ),
               ],
             ),
           ),
         )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
