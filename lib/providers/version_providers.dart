import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:savvy_cart/services/services.dart';

final versionServiceProvider = Provider<VersionService>((ref) {
  return VersionService();
});

final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  final versionService = ref.watch(versionServiceProvider);
  return await versionService.getPackageInfo();
});