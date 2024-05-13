import 'package:firebase_auth/firebase_auth.dart';
class AndroidAppleLoginUtil{
  static Future<String>  appleIdLogin ()async {
    final appleProvider = AppleAuthProvider();
    UserCredential _user =     await FirebaseAuth.instance.signInWithProvider(appleProvider);
     if(_user != null && _user.credential != null){
       final _token =  _user.additionalUserInfo?.profile?['sub'] ?? '';
       print("_user.additionalUserInfo.profile=${_user.additionalUserInfo?.profile}");
       return _token.toString();
     }else{
       return '';
     }
  }
}