import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

class HomeBodyView extends StatefulWidget {
  const HomeBodyView({super.key});

  @override
  State<HomeBodyView> createState() => _HomeBodyViewState();
}

class _HomeBodyViewState extends State<HomeBodyView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage('images/participants/background.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: SingleChildScrollView(child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 49, left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('images/participants/icon_white.png'),
                  width: 62,
                  height: 63,
                ),
                SizedBox(
                  height: 8,
                ),
                Constants.boldWhiteTextWidget('DigitalSDigitalS', 30),
                SizedBox(
                  height: 8,
                ),
                Constants.regularGreyTextWidget('Challenge deiption', 14)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16, left: 56, right: 56),
            height: 43,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(182, 246, 29, 1.0),
                  Color.fromRGBO(219, 219, 20, 1.0)
                ],
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Constants.boldBlackTextWidget('Play Now', 16),
                ),
                Positioned(
                    top: 6,
                    right: 6,
                    child: Image(
                      image: AssetImage('images/participants/next.png'),
                      width: 31,
                      height: 31,
                    ))
              ],
            ),
          )
        ],
      ),),
    );
  }
}
