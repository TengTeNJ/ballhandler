import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainingModeListView extends StatefulWidget {
  final void Function()? scanBleList;

  TrainingModeListView({this.scanBleList});

  @override
  State<TrainingModeListView> createState() => _TrainingModeListViewState();
}

class _TrainingModeListViewState extends State<TrainingModeListView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('GestureDetector==');
        if (widget.scanBleList != null) {
          widget.scanBleList!();
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        height: 205,
        width: Constants.screenWidth(context) - 32,
        decoration: BoxDecoration(
          // color: Colors.red,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage('images/ble/ble_bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 16, top: 21),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('images/participants/icon_white.png'),
                    width: 31,
                    height: 31,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Training Mode ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Container(
                    // color: Colors.red,
                      width: 16,
                      height: 16,
                      child: Image(
                        image: AssetImage('images/participants/question.png'),
                      ))
                ],
              ),
            ),
            Container(
              width: Constants.screenWidth(context) - 32,
              height: 20,
              margin: EdgeInsets.only(top: 10, left: 16, right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Constants.regularWhiteTextWidget('Easy -', 12),
                  SizedBox(width: 4,),
                  Row(
                    children: List.generate(5, (index) {
                      return Image(image: AssetImage(
                          'images/participants/five_star.png'),
                          width: 8,
                          height: 7.65,);
                    }),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 3),
              height: 44,
              child: SingleChildScrollView(
                child: Text(
                  maxLines: 2,
                  'ChallengeRulesChallengeRuleeRulesChallengeRulesChallenge RulesChallenge RulesChallenge Rules Challenge RulesChallenge Rules',
                  style: TextStyle(
                      height: 1.2,
                      color: Color.fromRGBO(203, 203, 203, 1.0),
                      fontSize: 12),
                ),
              ),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Container(
                        child: Consumer<UserModel>(
                            builder: (context, user, child) {
                              return Row(
                                children: [
                                  // Time
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      Image(
                                        image:
                                        AssetImage(
                                            'images/participants/time.png'),
                                        width: 16.8,
                                        height: 16.8,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Constants.regularWhiteTextWidget(
                                              '00:45', 14),
                                          Constants.regularWhiteTextWidget(
                                              'Time', 12),
                                        ],
                                      )
                                    ],
                                  ),
                                  // Participants
                                  SizedBox(
                                    width: 27,
                                  ),
                                  user.hasLogin == true
                                      ? Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'images/participants/person.png'),
                                        width: 16.8,
                                        height: 16.8,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Constants.regularWhiteTextWidget(
                                              '105', 14),
                                          Constants.regularWhiteTextWidget(
                                              'Participants', 12),
                                        ],
                                      )
                                    ],
                                  )
                                      : Container(),
                                ],
                              );
                            }),
                      )),
                      Image(
                        image: AssetImage('images/participants/next_green.png'),
                        width: 50,
                        height: 50,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
