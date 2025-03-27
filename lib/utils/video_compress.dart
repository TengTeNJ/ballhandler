import 'package:code/constants/constants.dart';
import 'package:video_compress/video_compress.dart';
/*
* 视频压缩
* */
class VideoCompressUtil{
  static Future<String>  comPress(String path) async{
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        path,
        quality: VideoQuality.LowQuality,
        deleteOrigin: false, // It's false by default
      );
      if(mediaInfo!= null && ISEmpty(mediaInfo.path)){
        return mediaInfo.path!;
      }
      return path;
    }

}