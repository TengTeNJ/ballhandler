// routes.dart
import 'package:code/controllers/account/login_page_controller.dart';
import 'package:code/controllers/account/privacy_page_controller.dart';
import 'package:code/controllers/participants/home_page_view.dart';
import 'package:code/controllers/participants/training_mode_controller.dart';
import 'package:flutter/material.dart';


class Routes {
  static const String home = '/';
  static const String login = 'login';
  static const String privacy = 'privacy';
  static const String trainingMode = 'trainingMode'; // 训练模式选择

  static RouteFactory onGenerateRoute = (settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePageController());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPageController());
      case privacy:
        return MaterialPageRoute(builder: (_) => PrivacyPageController());
      case trainingMode:
        return MaterialPageRoute(builder: (_) => TrainingModeController());
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