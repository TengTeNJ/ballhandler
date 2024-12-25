import 'package:code/views/participants/razor_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:tt_indicator/tt_indicator.dart';

import '../../constants/constants.dart';
import '../../utils/color.dart';
class RazorModeScrollView extends StatefulWidget {
  const RazorModeScrollView({super.key});

  @override
  State<RazorModeScrollView> createState() => _RazorModeScrollViewState();
}

class _RazorModeScrollViewState extends State<RazorModeScrollView> {
  int _currentIndex = 0;
   PageController  _pageController = PageController(initialPage: 0);
   List<List<String> >_datas = [['1','2','3','','',''],['4','5','6','7','8','9']];
   @override
   void initState() {
    // TODO: implement initState
    super.initState();
    _pageController.addListener(() {
      // 获取当前滑动页面的索引 (取整)
      int currentpage = _pageController.page!.round();
      if (_currentIndex != currentpage) {
        print('_currentIndex= ${_currentIndex} currentpage = ${currentpage}');
        setState(() {
          _currentIndex = currentpage;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final _size = (Constants.screenWidth(context) - 24*2 - 6*2) / 3.0;
    return Column(
      children: [
        Constants.mediumWhiteTextWidget('Beginner (Mode ${_currentIndex + 1})', 16,textAlign: TextAlign.center),
        SizedBox(height: 24,),
        Container(
          height: _size * 2 + 6,
          width: Constants.screenWidth(context) - 36,
          child: PageView.builder(
            controller: _pageController,
              itemBuilder: (context,index){
            return RazorGridView(imageNames: _datas[_currentIndex]);
          }),
        ),
        SizedBox(height: 24,),
        IndicatorView(
          count: 2,
          currentPage: _currentIndex,
          defaultColor: hexStringToColor('#6D6D6D'),
          currentPageColor: Colors.white,
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }
}
