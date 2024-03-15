import 'package:flutter/material.dart';
import '../../utils/navigator_util.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        NavigatorUtil.pop();
      },
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: 36,
            height: 36,
            color: Color.fromRGBO(135, 135, 151, 1.0),
            child: Container(
              width: 14,
              height: 14,
              child: Center(
                child: Image(
                  fit: BoxFit.fitWidth,
                  image: AssetImage('images/account/cancel.png'),
                  width: 14,
                  height: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


