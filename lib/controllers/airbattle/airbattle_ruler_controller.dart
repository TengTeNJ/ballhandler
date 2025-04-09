import 'package:code/views/airbattle/airbattle_rule_view.dart';
import 'package:code/widgets/account/cancel_button.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class AirBattleRulerController extends StatelessWidget {
  String startDate;
  String endDate;
  String monthString;
  String totalDays;
  AirBattleRulerController(
      {super.key, required this.startDate, required this.endDate,required this.monthString,required this.totalDays});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkControllerColor,
      body: Container(
        decoration: BoxDecoration(
          color: Constants.darkControllerColor,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: Constants.screenWidth(context) - 32,
                  height: 134,
                  child: Stack(
                    children: [
                      Positioned(
                          left: (Constants.screenWidth(context) -
                              32 -
                              606 / 265 * 134) /
                              2.0,
                          right: (Constants.screenWidth(context) -
                              32 -
                              606 / 265 * 134) /
                              2.0,
                          child: Image(
                            image: AssetImage(
                              'images/participants/fireworks.png',
                            ),
                            height: 134,
                            fit: BoxFit.fitHeight,
                          )),
                      Positioned(top: 0, right: 16, child: CancelButton()),
                      Positioned(
                        left: (Constants.screenWidth(context) - 32 - 69) / 2.0,
                        right: (Constants.screenWidth(context) - 32 - 69) / 2.0,
                        bottom: 16,
                        child: Image(
                          image: AssetImage(
                            'images/airbattle/top_icon.png',
                          ),
                          width: 69,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Constants.mediumWhiteTextWidget('Join ${monthString} Spring AirBattle!', 20),
                SizedBox(
                  height: 16,
                ),
                Constants.regularGreyTextWidget(
                    'Challenge yourself in Zigzag Mode with the Digital Stickhandling Trainer. Compete, track your progress, and win amazing prizes!',
                    16,
                    textAlign: TextAlign.start,
                    height: 1.5),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [Constants.boldWhiteTextWidget('How It Works:', 20)],
                ),
                SizedBox(
                  height: 8,
                ),
                AirBattleRuleView(
                    title:
                    'Challenge: Digital Stickhandling Trainer “Zigzag” shape.'),
                AirBattleRuleView(
                    title:
                    'Submissions: Submit up to 5 battles per day. Aim to beat your best score each time!'),
                AirBattleRuleView(
                    title:
                    'Duration: ${totalDays} days to compete, starting [${startDate}], ending [${endDate}].'),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [Constants.boldWhiteTextWidget('Leaderboard:', 20)],
                ),
                SizedBox(
                  height: 8,
                ),
                Constants.regularGreyTextWidget(
                    'Compete for Top Spots!\nTrack your rank against players worldwide and see how you compare.',
                    16,
                    height: 1.5,
                    textAlign: TextAlign.start),
                AirBattleRuleView(
                    title:
                    'Categories:\nBattle Champions: Track the highest scores/best reaction time\n Rising Stars: Celebrate the most improved players.\nConsistent Contenders: Recognize those who stayed active and participated the most.'),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [Constants.boldWhiteTextWidget('Win Prizes!:', 20)],
                ),
                SizedBox(
                  height: 8,
                ),
                AirBattleRuleView(
                    title: 'Top Performer: Free Ultimater Dangler 2.0'),
                AirBattleRuleView(
                    title: 'Rising Star (Most Improved): \$25 Store Cash'),
                AirBattleRuleView(title: 'Consistent Contender: \$25 Store Cash'),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [Constants.boldWhiteTextWidget('Why Compete?:', 20)],
                ),
                SizedBox(
                  height: 8,
                ),
                AirBattleRuleView(
                    title:
                    'Open to All: Anyone can join, even without a subscription!'),
                AirBattleRuleView(
                    title:
                    'Exclusive Rewards for subscribers: Win pucks, badges, and more!'),
                AirBattleRuleView(
                    title:
                    'Improve Your Skills: Track your progress and rise to the top.'),
                SizedBox(height: 16,),
                Row(
                  children: [Constants.boldWhiteTextWidget('Tie-Breaking Procedure', 20)],
                ),
                SizedBox(
                  height: 8,
                ),
                Constants.regularGreyTextWidget(
                    'Tie Breakers: In the event of a tie in any category, we will use the following procedure:',
                    16,
                    height: 1.5,
                    textAlign: TextAlign.start),
                SizedBox(
                  height: 8,
                ),
                AirBattleRuleView(
                    title:
                    'Raffle Draw: A random raffle may be used to determine the winner.'),
                AirBattleRuleView(
                    title:
                    'Top Performer: Participant consistency or/and personal top 10 average may be used to determine the winner.'),
                AirBattleRuleView(
                    title:
                    'Rising Star: The player with the greatest improvement from their starting score will win.'),
                AirBattleRuleView(
                    title:
                    'Consistent Contender: The player with the most valid submissions throughout the event will be awarded the win.'),
                SizedBox(height: 32,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
