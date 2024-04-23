import 'dart:io';

import 'package:code/controllers/participants/home_page_view.dart';
import 'package:code/models/global/game_data.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/root_page.dart';
import 'package:code/route/route.dart';
import 'package:code/utils/global.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    // 安卓虽然导入了json文件 可是仍然报错，可能是某方面原因导致不能自动初始化获取参数，所以手动加了参数
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: 'AIzaSyCsVdT0KIZIbqeQP4B7ISZDK_cne2E7fnA',
      appId: '1:217693202761:android:3c338005aa9ef70001d298',
      messagingSenderId: '217693202761',
      projectId: 'potent-hockey-8bae8',
      storageBucket: 'potent-hockey-8bae8.appspot.com',
    ));
  } else {
    await Firebase.initializeApp();
  }
  GetIt.I.registerSingleton<GameUtil>(GameUtil()); // 注册GameUtil实例
  runApp(UserProvider(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 初始化用户信息
    NSUserDefault.initUserInfo(context);
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: Routes.onGenerateRoute,
      home: RootPageController(),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
