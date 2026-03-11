import 'package:flutter/material.dart';

import '../../utils/ble_razor_data.dart';
import '../../utils/ble_razor_service_data.dart';
import '../../utils/shape_transformer.dart';

class TestRazorController extends StatefulWidget {
  const TestRazorController({super.key});

  @override
  State<TestRazorController> createState() => _TestRazorControllerState();
}

class _TestRazorControllerState extends State<TestRazorController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Razor变形控制模拟器'),
      ),
      body: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int leftValue1 = 0;
  int rightValue1 = 0;
  int leftValue2 = 0;
  int rightValue2 = 0;
  bool first_forward1 = true; // 电机1正转
  bool first_forward2 = true; // 电机2正转
  bool second_forward1 = true; // 电机1正转
  bool second_forward2 = true; // 电机2正转
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Switch(
                value: first_forward1,
                onChanged: (value) {
                  setState(() {
                    first_forward1 = value;
                  });
                },
              ),
              Switch(
                value: first_forward2,
                onChanged: (value) {
                  setState(() {
                    first_forward2 = value;
                  });
                },
              ),
            ],
          ),
          // 第一行：左右两个滑块
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('第一条指令电机1'),
                  Slider(
                    min: 0,
                    max: 255,
                    value: leftValue1.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        leftValue1 = value.toInt();
                      });
                    },
                  ),
                  Text('当前值: $leftValue1'),
                ],
              ),
              Container(color: Colors.red,height: 1,),
              SizedBox(height: 16,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('第一条指令电机2'),
                  Slider(
                    min: 0,
                    max: 255,
                    value: rightValue1.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        rightValue1 = value.toInt();
                      });
                    },
                  ),
                  Text('当前值: $rightValue1'),
                ],
              ),
              Container(color: Colors.red,height: 1,),
              SizedBox(height: 16,),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Switch(
                value: second_forward1,
                onChanged: (value) {
                  setState(() {
                    second_forward1 = value;
                  });
                },
              ),
              Switch(
                value: second_forward2,
                onChanged: (value) {
                  setState(() {
                    second_forward2 = value;
                  });
                },
              ),
            ],
          ),
          // 第二行：左右两个滑块
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('第二条指令电机1'),
                  Slider(
                    min: 0,
                    max: 255,
                    value: leftValue2.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        leftValue2 = value.toInt();
                      });
                    },
                  ),
                  Text('当前值: $leftValue2'),
                ],
              ),
              Container(color: Colors.red,height: 1,),
              SizedBox(height: 16,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('第二条指令电机2'),
                  Slider(
                    min: 0,
                    max: 255,
                    value: rightValue2.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        rightValue2 = value.toInt();
                      });
                    },
                  ),
                  Text('当前值: $rightValue2'),
                ],
              ),
              Container(color: Colors.red,height: 1,),
              SizedBox(height: 16,),
            ],
          ),
          const SizedBox(height: 20),

          // 第三行：确定按钮
          ElevatedButton(
            onPressed: () {
              // 点击确定按钮时的逻辑
              List<BleRazorMotorStatu>  forwards = [BleRazorMotorStatu.forward,BleRazorMotorStatu.forward];
              if(!first_forward1){
                forwards.removeAt(0);
                forwards.insert(0, BleRazorMotorStatu.reversal);
              }
              if(!first_forward2){
                forwards.removeAt(1);
                forwards.insert(1, BleRazorMotorStatu.reversal);
              }
              List<int>times = [leftValue1,rightValue1];
              List<int>data1 = motorControlData(motorStatus: forwards,timers: times);

              List<BleRazorMotorStatu>  forwards2 = [BleRazorMotorStatu.forward,BleRazorMotorStatu.forward];
              if(!second_forward1){
                forwards2.removeAt(0);
                forwards2.insert(0, BleRazorMotorStatu.reversal);
              }
              if(!second_forward2){
                forwards2.removeAt(1);
                forwards2.insert(1, BleRazorMotorStatu.reversal);
              }
              List<int>times2 = [leftValue2,rightValue2];
              List<int>data2 = motorControlData(motorStatus: forwards2,timers: times2);
              print('++++++++++++${[data1]}');
              CommandManager.sendCommandsSequentially([data1,data2]);

              print('第一行左值: $leftValue1, 右值: $rightValue1');
              print('第二行左值: $leftValue2, 右值: $rightValue2');
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
