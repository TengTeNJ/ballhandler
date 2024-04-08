import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/models/http/user_model.dart';
import 'package:code/services/http/account.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:date_format/date_format.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/*登录类型*/
enum LoginType {
  appleID,
  google,
  faceBook,
}

/*登录util*/
class LoginUtil {
  static Future<ApiResponse<User>> thirdLogin(LoginType type) async {

    if (type == LoginType.google) {
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
        'email',
      ],
      );
      // 谷歌登录
      try {
        GoogleSignInAccount? googleUser = await _googleSignIn.signIn(
        );
        if (googleUser != null) {
          final _map = {
            "avatarUrl": googleUser.photoUrl ?? '',
            "gender": 0,
            "nickName": googleUser.displayName ?? '--',
            "thirdLoginType": 2,
            "thirdOpenId": googleUser.id
          };
          final _response = await Account.thirdLogin(_map);
          if(_response.success){
            NSUserDefault.setKeyValue(kUserEmail, googleUser.email ?? '--');
          }
          return _response;
        }
        // 登录成功后的逻辑，可以跳转到下一个页面或执行其他操作
      } catch (error) {
        print(error.toString());
        return ApiResponse(success: false, errorMessage: error.toString());
      }
    } else if (type == LoginType.appleID) {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(clientId: 'com.potent.hockey.train',redirectUri:Uri.parse('https://scarce-wood-spice.glitch.me/callbacks/sign_in_with_apple'))
      );
      final _map = {
        "avatarUrl": '',
        "gender": 0,
        "nickName": credential.givenName,
        "thirdLoginType": 1,
        "thirdOpenId": credential.userIdentifier
      };
      return await Account.thirdLogin(_map);
    }
    return ApiResponse(success: false);
  }
}
