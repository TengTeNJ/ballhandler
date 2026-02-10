import 'package:code/utils/system_device.dart';
import 'package:code/views/dialog/dialog.dart';
import 'package:flutter/cupertino.dart';

import '../services/http/utils.dart';

class VersionUtils {
  static int compareVersion(String v1, String v2) {
    List<int> v1List = v1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> v2List = v2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    int maxLen = v1List.length > v2List.length ? v1List.length : v2List.length;

    for (int i = 0; i < maxLen; i++) {
      int num1 = i < v1List.length ? v1List[i] : 0;
      int num2 = i < v2List.length ? v2List[i] : 0;

      if (num1 > num2) return 1;
      if (num1 < num2) return -1;
    }

    return 0;
  }

  static bool needForceUpdate(String local, String minSupport) {
    return compareVersion(local, minSupport) < 0;
  }

 static  Future<void> checkAppVersion(BuildContext context) async {
    try {
      /// 1. 后台获取版本配置
      final _model = await Utils.getLastVersion();
      final serverVersion = _model.data;

      if (serverVersion == null) return;

      String minSupportVersion = serverVersion.minSupportVersion ?? '1.0';
      String latestVersion = serverVersion.appVersion ?? '1.0';
      String versionRemark = serverVersion.versionRemark ?? '';
      String buttonName = serverVersion.versionName;

      /// 2. 获取本地 App 版本
      String localVersion = await SystemUtil.getApplicationOnlyVersion();

      print('📱 本地版本: $localVersion');
      print('☁️ 最低支持版本: $minSupportVersion');
      print('🆕 最新版本: $latestVersion');

      /// 3. 强制更新判断
      bool needForceUpdate = compareVersion(localVersion, minSupportVersion) < 0;

      /// 4. 非强制更新（有新版本）
      bool hasNewVersion = compareVersion(localVersion, latestVersion) < 0;

      if (needForceUpdate) {
        showUpdateDialog(
          context,
          title: 'Version too low',
          content: versionRemark.isNotEmpty
              ? versionRemark
              : 'The current version is too low. Please update and continue using it.',
          force: true,
          buttonName: buttonName
        );
      } else if (hasNewVersion) {
        showUpdateDialog(
          context,
          title: 'New version discovered',
          content: versionRemark.isNotEmpty
              ? versionRemark
              : 'A new version has been found. Should I update immediately?',
          force: false,
          buttonName: buttonName

        );
      }
    } catch (e) {
      print('❌ 版本检测失败: $e');
    }
  }

}
