import 'dart:io';
import 'package:code/services/sqlite/data_base.dart';
import '../constants/constants.dart';
class VideoUtil {
  Future<dynamic> deleteFileInBackground(List<VideoPathModel> paths) async {
    final List<Future<dynamic>> futures = [];

    paths.forEach((element) async{
      final file = File(element.videoPath);
      if (file.existsSync()) {
        print('删除文件---${element.videoPath}');
        file.deleteSync();
        futures.add(DatabaseHelper().deletevVideoPathData(kDataBaseTVideoableName, int.parse(element.id)));
      }
    });
    return await Future.wait(futures);
  }

  static  Future<double> getVideoFileSize(String filePath) async {
    File file = File(filePath);
    if (await file.exists()) {
      int sizeInBytes = await file.length();
      // 将文件大小转换为 MB
      double sizeInMb = sizeInBytes / (1024 * 1024);
      return sizeInMb;
    } else {
      throw FileSystemException("File not found");
    }
  }


}
