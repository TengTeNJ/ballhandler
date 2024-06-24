import 'package:code/constants/constants.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

class MemberShipDetailController extends StatelessWidget {
  const MemberShipDetailController({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.baseControllerColor,
      appBar: CustomAppBar(
        customBackgroundColor: Constants.baseControllerColor,
        showBack: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16,right: 16),
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Constants.customTextWidget('Exclusive Membership Benefits:', 30, '#FBBA00',fontWeight: FontWeight.bold,textAlign: TextAlign.start),
              SizedBox(height: 42,),
              Constants.boldWhiteTextWidget('Free Digital Stickhandling Trainer with 1-Year Subscription', 20,textAlign: TextAlign.start,height: 1.25),
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage('images/launch/done.png'),
                    width: 16,
                    height: 16,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    color: Colors.red,
                    width: Constants.screenWidth(context) - 72,
                    child: Constants.boldWhiteTextWidget(
                        textAlign: TextAlign.start,
                        "30-Day Risk-Free Product Trial: First month’s fee covers shipment and handling",
                        14,
                        height: 1.2),
                  )
                ],
              ),
              SizedBox(height: 18,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage('images/launch/done.png'),
                    width: 16,
                    height: 16,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: Constants.screenWidth(context) - 72,
                    child: Constants.boldWhiteTextWidget(
                        textAlign: TextAlign.start,
                        "Extended 12-Month Warranty on your product.",
                        14,
                        height: 1.2),
                  )
                ],
              ),
              SizedBox(height: 97,),
              Image(
                image: AssetImage("images/launch/launch_3.png"),
                width: 246,
                height: 221,
                // fit: BoxFit.,
              ),
              SizedBox(height: 56,),
              Constants.boldWhiteTextWidget('Full Privilege to\nPotent Hockey DanglerStar App', 20,textAlign: TextAlign.start,height: 1.25),
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('images/launch/done.png'),
                    width: 16,
                    height: 16,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: Constants.screenWidth(context) - 72,
                    child: Constants.boldWhiteTextWidget(
                        textAlign: TextAlign.start,
                        "Daily Challenges",
                        14,
                        height: 1.2),
                  )
                ],
              ),
              SizedBox(height: 14,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('images/launch/done.png'),
                    width: 16,
                    height: 16,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: Constants.screenWidth(context) - 72,
                    child: Constants.boldWhiteTextWidget(
                        textAlign: TextAlign.start,
                        "Air-Batt Challenges",
                        14,
                        height: 1.2),
                  )
                ],
              ),
              SizedBox(height: 14,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('images/launch/done.png'),
                    width: 16,
                    height: 16,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: Constants.screenWidth(context) - 72,
                    child: Constants.boldWhiteTextWidget(
                        textAlign: TextAlign.start,
                        "Leaderboards",
                        14,
                        height: 1.2),
                  )
                ],
              ),
              SizedBox(height: 14,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('images/launch/done.png'),
                    width: 16,
                    height: 16,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: Constants.screenWidth(context) - 72,
                    child: Constants.boldWhiteTextWidget(
                        textAlign: TextAlign.start,
                        "Performance & Progress Tracking",
                        14,
                        height: 1.2),
                  )
                ],
              ),
              SizedBox(height: 14,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('images/launch/done.png'),
                    width: 16,
                    height: 16,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: Constants.screenWidth(context) - 72,
                    child: Constants.boldWhiteTextWidget(
                        textAlign: TextAlign.start,
                        "Earn Awards and Rewards",
                        14,
                        height: 1.2),
                  )
                ],
              ),
              SizedBox(height: 14,),
              SizedBox(height: 112,),
            ],
          ),
        ),
      ),
    );
  }
}
