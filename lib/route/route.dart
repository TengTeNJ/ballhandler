// routes.dart
import 'package:code/controllers/account/login_page_controller.dart';
import 'package:code/controllers/participants/home_page_view.dart';
import 'package:flutter/material.dart';


class Routes {
  static const String home = '/';
  static const String login = 'login';

  static RouteFactory onGenerateRoute = (settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePageController());
      case login:
      // 可以在这里处理参数
        return MaterialPageRoute(builder: (_) => LoginPageController());
      default:
        return _errorRoute();
    }
  };

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}