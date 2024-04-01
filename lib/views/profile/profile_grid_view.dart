import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class ProfileGridView extends StatefulWidget {
  const ProfileGridView({super.key});

  @override
  State<ProfileGridView> createState() => _ProfileGridViewState();
}

class _ProfileGridViewState extends State<ProfileGridView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      width: (Constants.screenWidth(context) - 56) / 2.0,
      decoration: BoxDecoration(
          color: hexStringToColor('#3E3E55'),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 18,right: 12),child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image(
                image: AssetImage('images/profile/time.png'),
                width: 28,
                height: 22,
              )
            ],
          ),),
          SizedBox(height: 12,),
          Padding(padding: EdgeInsets.only(left: 12),child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '0.6',
                    style: TextStyle(
                        fontSize: 40, color: Colors.white, height: 0.8),
                  ),
                  Text(
                    'Sec',
                    style: TextStyle(
                        fontSize: 10, color: Colors.white, height: 0.8),
                  )
                ],
              ),
              SizedBox(height: 4,),
              Text('Best React Time',style: TextStyle(color: hexStringToColor('#B1B1B1'),fontSize: 10),)
            ],
          ),),
        ],
      ),
    );
  }
}
