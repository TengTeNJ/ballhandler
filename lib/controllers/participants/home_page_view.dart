import 'package:code/constants/constants.dart';
import 'package:code/views/participants/home_body_view.dart';
import 'package:code/views/participants/overall_data_view.dart';
import 'package:code/views/participants/user_info_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:tt_indicator/tt_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePageController extends StatefulWidget {
  const HomePageController({super.key});

  @override
  State<HomePageController> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageController> {
  int _currentIndex = 0;
   PageController _pageController = PageController();
  final List<Widget> _pageViews = [
    HomeBodyView(),
    HomeBodyView(),
    HomeBodyView()
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
        // 获取当前滑动页面的索引 (取整)
        int currentpage = _pageController.page!.round();
        if(_currentIndex !=  currentpage){
          setState(() {
            _currentIndex = currentpage;
          });
        }
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(
        title: '',
      ),
      body: Container(
        margin: EdgeInsets.only(left: 0, right: 0),
        child: Column(
          children: [
            UserInfoView(),
            SizedBox(
              height: 24,
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              child: OverAllDataView(),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: _pageViews[index],
                    );
                  }),
            ),
            Container(
              height: 34,
              child: Column(
                children: [
                  Container(
                    height: 30,
                    child: IndicatorView(
                      count: 3,
                      currentPage: _currentIndex,
                      defaultColor: Color.fromRGBO(204, 204, 204, 1.0),
                      currentPageColor: Constants.baseStyleColor,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
