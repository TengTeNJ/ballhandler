import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:code/services/sqlite/data_base.dart';
import '../constants/constants.dart';

class VideoUtil {
  void deleteFileInBackground(List<VideoPathModel> paths) async {
    ReceivePort receivePort = ReceivePort();

    await Isolate.spawn(_deleteFileTask, receivePort.sendPort);

    SendPort? sendPort = await receivePort.first;
    Completer completer = Completer();
    if (sendPort != null) {
      sendPort.send([paths]);
    }
  }

  void _deleteFileTask(SendPort sendPort) {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      List<VideoPathModel> filePaths = message[0];
      try {
        filePaths.forEach((element) {
          final file = File(element.videoPath);
          if (file.existsSync()) {
            print('删除文件---${element.videoPath}');
            file.deleteSync();
            DatabaseHelper().deletevVideoPathData(kDataBaseTVideoableName, int.parse(element.id));
          }
        });
      } catch (e) {
      }
    });
  }
}
