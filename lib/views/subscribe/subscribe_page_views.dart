import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:tt_indicator/tt_indicator.dart';

class SubscribePageViews extends StatefulWidget {
  const SubscribePageViews({super.key});

  @override
  State<SubscribePageViews> createState() => _SubscribePageViewsState();
}

class _SubscribePageViewsState extends State<SubscribePageViews> {
  late PageController _pageController;
  int _currentIndex = 0;
  List<String> _titles = [
    'Customizable training mode for your daily challenges and air battles',
    'Record your practices,or airbattles in real-time',
    'Store your videos to the cloud for playback anytime',
    'Compete in monthly air battles and win prizes',
    'View your performance stats and highlights after each session',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _pageController.addListener(() {
      // 获取当前滑动页面的索引 (取整)
      int currentpage = _pageController.page!.round();
      if (_currentIndex != currentpage) {
        setState(() {
          _currentIndex = currentpage;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: PageView.builder(
                  itemCount: _titles.length,
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: hexStringToColor('#4099CE'),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(child: Image(
                            width: 36,
                            fit: BoxFit.contain,
                            image: AssetImage('images/launch/subscribe_3${index + 1}.png',),
                          ),),
                        ),
                        SizedBox(
                          height: 36,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 32, right: 32),
                          width: Constants.screenWidth(context) - 64,
                          child: Constants.regularWhiteTextWidget(
                              _titles[index], 16,height: 1.3),
                        ),
                      ],
                    );
                  })),
          IndicatorView(
            currentPage: _currentIndex,
            count: _titles.length,
            horizontal: 8,
            currentPageColor: Constants.baseStyleColor,
          )
        ],
      ),
    );
  }
}
