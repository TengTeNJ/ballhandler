import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/*
* 开始录制
* */
Future<bool> startRecord() async {
  bool start = await FlutterScreenRecording.startRecordScreen('temp');
  if (start == false) {
    print('用户禁止授权抓屏');
  }
  return start;
}

/*结束抓屏*/
Future<String> stopRecord() async {
  String videoPath = await FlutterScreenRecording.stopRecordScreen;
  EasyLoading.show();
  await Future.delayed(Duration(seconds: 3),(){
    EasyLoading.dismiss();
    return videoPath;
  });

  return videoPath;
}

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }