import 'package:package_info_plus/package_info_plus.dart';

class VersionService {
  Future<PackageInfo> getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> getBuildNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  Future<String> getFullVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }
}