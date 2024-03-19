import 'package:code/controllers/account/login_page_controller.dart';
import 'package:code/controllers/account/send_email_controller.dart';
import 'package:code/controllers/participants/home_page_view.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/widgets/navigation/customBottomNavigationBar.dart';
import 'package:flutter/material.dart';

class RootPageController extends StatefulWidget {
  const RootPageController({super.key});

  @override
  State<RootPageController> createState() => _RootPageControllerState();
}

class _RootPageControllerState extends State<RootPageController> {
  int _currentIndex = 0;
  late PageController _pageController;
  final List<StatefulWidget> _pageViews = [
    HomePageController(),
    HomePageController(),
    HomePageController(),
    HomePageController(),
  ];
  @override
  void initState() {
    super.initState();
    _pageController = PageController()
     ..addListener(() {
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
    NavigatorUtil.init(context);
    return Scaffold(
      resizeToAvoidBottomInset:false,
      bottomNavigationBar: CustomBottomNavigationBar(onTap: (index){
        if(index == 1){
         // NavigatorUtil.push('login');
         NavigatorUtil.present(LoginPageController());
         // NavigatorUtil.present(TestController());
         // NavigatorUtil.present(SendEmailController());
        }
      },),
      body: _pageViews[_currentIndex],
    );
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
