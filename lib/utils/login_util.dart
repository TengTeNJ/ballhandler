import 'package:code/models/http/user_model.dart';
import 'package:code/services/http/account.dart';
import 'package:code/utils/http_util.dart';
import 'package:google_sign_in/google_sign_in.dart';

/*登录类型*/
enum LoginType {
  appleID,
  google,
  faceBook,
}
/*登录util*/
class LoginUtil {
    static  Future<ApiResponse<User>> thirdLogin(LoginType type) async{
       GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
       if(type == LoginType.google){
         // 谷歌登录
         try {
           GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
           if(googleUser != null){
             final _map = {
               "avatarUrl": googleUser.photoUrl,
               "gender": 0,
               "nickName": googleUser.displayName,
               "thirdLoginType": 1,
               "thirdOpenId": googleUser.id
             };
            return await Account.thirdLogin(_map);
           }
           // 登录成功后的逻辑，可以跳转到下一个页面或执行其他操作
         } catch (error) {
           print(error);
         }
       }
       return ApiResponse(success: false);
     }
}