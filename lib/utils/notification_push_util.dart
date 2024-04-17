import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationPushUtil {
  static sendTokenToRemoteServer() async{
    final fcmToken = await FirebaseMessaging.instance.getToken();
  }
}