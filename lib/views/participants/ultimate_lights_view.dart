import 'package:code/constants/constants.dart';
import 'package:code/models/game/light_ball_model.dart';
import 'package:code/utils/game_util.dart';
import 'package:code/utils/global.dart';
import 'package:flutter/material.dart';

class UltimateLightsView extends StatefulWidget {
  double width;
  double height;
  List<LightBallModel> datas;
  UltimateLightsView({required this.width, required this.height,required this.datas});

  @override
  State<UltimateLightsView> createState() => _UltimateLightsViewState();
}


class _UltimateLightsViewState extends State<UltimateLightsView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: (widget.datas == null || widget.datas!.length == 0) ? [] : widget.datas!.map((ball){
        if(!ball.show){
          return Container();
        }else{
          if(ball.left! > 0){
            return Positioned(
                left: widget.width * ball.left!,
                bottom: widget.height * ball.bottom!,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9), color: ball.color),
                ));
          }else{
            return Positioned(
                right: widget.width * ball.right!,
                bottom: widget.height * ball.bottom!,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9), color:ball.color),
                ));
          }
        }
      }).toList()
      // children: [
      //   // 1
      //   Positioned(
      //       left: widget.width * 0.0526,
      //       bottom: widget.height * 0.0842,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightRedColor),
      //       )),
      //   // 2
      //   Positioned(
      //       left: widget.width * 0.170,
      //       bottom: widget.height * 0.0842,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightRedColor),
      //       )),
      //   // 3
      //   Positioned(
      //       left: widget.width * 0.108,
      //       bottom: widget.height * 0.236,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightBlueColor),
      //       )),
      //   // 4
      //   Positioned(
      //       left: widget.width * 0.1177,
      //       bottom: widget.height * 0.342,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightRedColor),
      //       )),
      //   // 5
      //   Positioned(
      //       left: widget.width * 0.145429,
      //       bottom: widget.height * 0.6712,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightRedColor),
      //       )),
      //   // 6
      //   Positioned(
      //       left: widget.width * 0.295,
      //       bottom: widget.height * 0.818,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightRedColor),
      //       )),
      //   // 7
      //   Positioned(
      //       left: widget.width * 0.295,
      //       bottom: widget.height * 0.5679,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightRedColor),
      //       )),
      //   // 8
      //   Positioned(
      //       left: widget.width * 0.363,
      //       bottom: widget.height * 0.679,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightBlueColor),
      //       )),
      //   // 9
      //   Positioned(
      //       left: widget.width * 0.422,
      //       bottom: widget.height * 0.6956,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightRedColor),
      //       )),
      //   // 10
      //   Positioned(
      //       left: widget.width * 0.611,
      //       bottom: widget.height * 0.679,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightBlueColor),
      //       )),
      //   // 11
      //   Positioned(
      //       left: widget.width * 0.5512,
      //       bottom: widget.height * 0.6956,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightRedColor),
      //       )),
      //   // 12
      //   Positioned(
      //       left: widget.width * 0.673,
      //       bottom: widget.height * 0.818,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightRedColor),
      //       )),
      //   // 13
      //   Positioned(
      //       left: widget.width * 0.673,
      //       bottom: widget.height * 0.5679,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightRedColor),
      //       )),
      //   // 14
      //   Positioned(
      //       left: widget.width * 0.835,
      //       bottom: widget.height * 0.6712,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightRedColor),
      //       )),
      //   // 15
      //   Positioned(
      //       right: widget.width * 0.1150,
      //       bottom: widget.height * 0.342,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightRedColor),
      //       )),
      //   // 16
      //   Positioned(
      //       right: widget.width * 0.108,
      //       bottom: widget.height * 0.236,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightBlueColor),
      //       )),
      //   // 17
      //   Positioned(
      //       right: widget.width * 0.170,
      //       bottom: widget.height * 0.0842,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightRedColor),
      //       )),
      //   // 18
      //   Positioned(
      //       right: widget.width * 0.0526,
      //       bottom: widget.height * 0.0842,
      //       child: Container(
      //         width: 18,
      //         height: 18,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(9), color: Constants.baseLightRedColor),
      //       )),
      // ],
    );
  }
}
