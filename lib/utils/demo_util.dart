import 'dart:async';
import 'dart:ui';
/*游戏demo效果演示*/
class DemoUtil{
  Timer? _razorPeriodTimer; // 周期执行定时器
  Timer? _razorGameTimer; // 自动刷新游戏定时器
  Timer? _razorHandleTimer; // 游戏过程中动作
  // 每秒执行的动作
   VoidCallback razorPeriodAction;
  // 每3秒执行的动作
   VoidCallback razorGamection;
  // 每3秒后延迟1.5秒执行的动作
   VoidCallback razorHandleAction;
   /*Razor Demo 效果 构造函数*/
   DemoUtil.razorDemo({required this.razorPeriodAction,required this.razorGamection,required this.razorHandleAction});
   void razorStart(){
        _razorPeriodTimer = Timer.periodic(Duration(seconds: 1), (timer){
           this.razorPeriodAction();
        });
        _razorGameTimer = Timer.periodic(Duration(seconds: 3), (timer){
          this.razorGamection();
          Future.delayed(Duration(milliseconds: 2000),(){
            this.razorHandleAction();
          });
        });
   }

   void razorStop(){
       _razorPeriodTimer?.cancel();
       _razorGameTimer?.cancel();
   }

}

/*
   * demo 数据
   * */
 List<List<String>> demoDatas(){
  List<List<String>> _datas = [];
  _datas.addAll([
    [
      '8t1',
      '正1'
    ],
    [
      '1t1',
      '反1'
    ],
  ]);
  _datas.addAll([
    [
      '1t3',
      '正2'
    ],
    [
      '3t3',
      '反1'
    ],
  ]);
  _datas.addAll([
    [
      '3t6',
      '正3'
    ],
    [
      '6t6',
      '反2'
    ],
  ]);
  _datas.addAll([
    [
      '6t7',
      '正1'
    ],
    [
      '7t7',
      '反1'
    ],
  ]);
  _datas.addAll([
    [
      '7t2',
      '正1'
    ],
    [
      '2t2',
      '反1'
    ],
  ]);
  // _datas.addAll([
  //   [
  //     '2t1',
  //     '正3'
  //   ],
  //   [
  //     '1t1',
  //     '反3'
  //   ],
  // ]);
  return _datas;
}