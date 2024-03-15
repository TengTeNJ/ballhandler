// routes.dart
import 'package:code/controllers/account/login_page_controller.dart';
import 'package:code/controllers/account/privacy_page_controller.dart';
import 'package:code/controllers/participants/home_page_view.dart';
import 'package:flutter/material.dart';


class Routes {
  static const String home = '/';
  static const String login = 'login';
  static const String privacy = 'privacy';

  static RouteFactory onGenerateRoute = (settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePageController());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPageController());
      case privacy:
        return MaterialPageRoute(builder: (_) => PrivacyPageController());
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