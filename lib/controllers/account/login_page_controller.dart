import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';
class LoginPageController extends StatefulWidget {
  const LoginPageController({super.key});

  @override
  State<LoginPageController> createState() => _LoginPageControllerState();
}

class _LoginPageControllerState extends State<LoginPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(child: Text('123'),),
    );
  }
}
