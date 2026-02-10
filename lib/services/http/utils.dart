import 'package:code/utils/http_util.dart';
import 'dart:io';

import '../../constants/constants.dart';

class VersionModel {
  int? versionId;
  String versionName = '';
  String appVersion = '1.0';
  String minSupportVersion = '1.0';
  String versionRemark = ''; // 版本备注

  @override
  String toString() {
    // TODO: implement toString
    return '版本信息{版本号: $appVersion,最小版本号: $minSupportVersion,版本描述: $versionRemark},';
  }
}

class Utils {
  /*获取最新的APP版本*/
  static Future<ApiResponse<VersionModel>> getLastVersion() async {
    final _data = {
      "versionType": getVersionType().toString(),
    };
    final response = await HttpUtil.get('/api/appVersion/getLastVersion', _data,
        showLoading: false);
    VersionModel _model = VersionModel();
    Map _map = response.data['data'];
    if (_map != null) {
      _model.versionId = ISEmpty(_map['versionId']) ? 0 : (_map['versionId']);
      _model.versionName =
          ISEmpty(_map['versionName']) ? '' : (_map['versionName']);
      _model.appVersion =
          ISEmpty(_map['appVersion']) ? '' : (_map['appVersion']);
      _model.minSupportVersion =
          ISEmpty(_map['minSupportVersion']) ? '' : (_map['minSupportVersion']);
      _model.versionRemark =
          ISEmpty(_map['versionRemark']) ? '' : (_map['versionRemark']);
    }
    return ApiResponse(success: response.success, data: _model);
  }

  static int getVersionType() {
    if (Platform.isAndroid) {
      return 1;
    } else if (Platform.isIOS) {
      return 2;
    }
    return 2; // 兜底
  }
}
