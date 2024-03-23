import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/participants/fireworks_animation-view.dart';
import 'package:code/views/participants/game_over_data_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameFinishController extends StatefulWidget {
  final GameOverModel dataModel;

  GameFinishController({required this.dataModel});

  @override
  State<GameFinishController> createState() => _GameFinishControllerState();
}

class _GameFinishControllerState extends State<GameFinishController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.darkThemeColor,
        body: SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Constants.appBarHeight,
            ),
            Container(
              margin: EdgeInsets.only(left: 36, right: 36),
              // color: Colors.red,
              height: 172,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: 132,
                      child: ImageAnimation(),
                    ),
                    top: 0,
                    left: 0,
                    right: 0,
                  ),
                  Positioned(
                      bottom: 0,
                      left: (Constants.screenWidth(context) - 72 - 112) / 2.0,
                      child: Image(
                        width: 112,
                        height: 112,
                        image: AssetImage('images/participants/done.png'),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ), // 撒花
            Consumer<UserModel>(builder: (context, user, child) {
              return Constants.boldWhiteTextWidget(
                  'Good Job,${user.userName}', 24);
            }),
            SizedBox(
              height: 8,
            ),
            Constants.regularWhiteTextWidget(
                "You've completed your challenge!\nKeep improving your skills!",
                16,
                maxLines: 2),
            SizedBox(
              height: 38,
            ),
            GameOverDataView(dataModel: widget.dataModel),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Constants.regularWhiteTextWidget(
                    'The storage space is full', 14),
                SizedBox(
                  width: 4,
                ),
                Text(
                  ' My Video',
                  style: TextStyle(
                      color: hexStringToColor('#27B6F5'), fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 56,),
            GestureDetector(
              onTap: (){
                print('save data');
              },
              child: Container(
                margin: EdgeInsets.only(left: 24,right: 24),
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(182, 246, 29, 1.0),
                      Color.fromRGBO(219, 219, 20, 1.0)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Constants.boldBlackTextWidget('SAVE', 16),),
              ),
            ),
            GestureDetector(
              onTap: (){
                print('delete data');
              },
              child: Container(
                margin: EdgeInsets.only(left: 24,right: 24),
                height: 32,
                child: Center(child: Text('Delete',style: TextStyle(color: hexStringToColor('#B1B1B1')),),),
              ),
            )
          ],
        ),)
        // body: Center(child: GameOverDataView(dataModel: widget.dataModel,),),
        );
  }
}
