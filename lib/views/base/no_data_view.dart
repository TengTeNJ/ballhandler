import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';
class NoDataView extends StatelessWidget {
  const NoDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('images/base/no_data.png'),
              width: 54,
              height: 64,
            ),
            SizedBox(
              height: 24,
            ),
            Constants.mediumGreyTextWidget('Nothing to see here yet', 20),
          ],
        ),
      ),
    );
  }
}
