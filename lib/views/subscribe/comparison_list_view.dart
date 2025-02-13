import 'package:code/constants/constants.dart';
import 'package:code/models/subscribe/subscribe_mode.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class ComparisonListView extends StatelessWidget {
  const ComparisonListView({super.key});

  @override
  Widget build(BuildContext context) {
    List<SubscribeMode> _datas = getSubscribeModeList();
    return Container(
      // color: Colors.red,
      width: Constants.screenWidth(context) - 48,
      height: _datas.length * 52,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(), // 禁止滑动
          padding: EdgeInsets.zero, // 去除顶部和底部的间距
          itemCount: _datas.length,
          itemBuilder: (context, index) {
            return Container(
              height: 52,
              color: index % 2 == 0
                  ? hexStringToColor('#404050')
                  : hexStringToColor('#292936'),
              child: Padding(
                padding: EdgeInsets.only(left: 8, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(child: Constants.mediumWhiteTextWidget(_datas[index].title, 14,textAlign: TextAlign.start),width: 130,),
                    Container(child: Center(child: ISEmpty(_datas[index].basicTitle)
                        ? Image(
                      image: AssetImage(_datas[index].basicAccess
                          ? 'images/subscribe/yes.png'
                          : 'images/subscribe/no.png'),
                      width: _datas[index].basicAccess ? 16 : 12,
                      fit: BoxFit.contain,
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(_datas[index].basicAccess
                              ? 'images/subscribe/yes.png'
                              : 'images/subscribe/no.png'),
                          width: _datas[index].basicAccess ? 16 : 12,
                          fit: BoxFit.contain,
                        ),
                        Constants.regularGreyTextWidget(
                            _datas[index].basicTitle, 14)
                      ],
                    ),),width: 50,),
                   Container(child:  Center(child: ISEmpty(_datas[index].membershipTitle)
                       ? Image(
                     image: AssetImage(_datas[index].membershipAccess
                         ? 'images/subscribe/yes.png'
                         : 'images/subscribe/no.png'),
                     width: _datas[index].membershipAccess ? 16 : 12,
                     fit: BoxFit.contain,
                   )
                       : Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Image(
                         image: AssetImage(_datas[index].membershipAccess
                             ? 'images/subscribe/yes.png'
                             : 'images/subscribe/no.png'),
                         width: _datas[index].membershipAccess ? 16 : 12,
                         fit: BoxFit.contain,
                       ),
                       Constants.regularBaseTextWidget(
                           _datas[index].membershipTitle, 14)
                     ],
                   ),),width: 65,)
                  ],
                ),
              ),
            );
          }),
    );
  }
}
