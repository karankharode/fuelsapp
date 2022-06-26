import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtil {
  static final DeviceInfoUtil instance = DeviceInfoUtil._instantiate();

  DeviceInfoUtil._instantiate();

  Future<DeviceInfoModel> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String dateTime = DateTime(2020).millisecondsSinceEpoch.toString();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String brand = androidInfo.brand ?? "";
      String model = androidInfo.model ?? "";
      String os_version = androidInfo.version.release.toString();
      String app_version = "1.2.3";
      String device_id = androidInfo.androidId.toString() + dateTime;
      // String device_id = androidInfo.androidId.toString() + dateTime ?? "";

      // //debugPrint('Running on ${androidInfo.model}');
      return DeviceInfoModel(brand, model, os_version, app_version, device_id);
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      String brand = iosInfo.systemName ?? "";
      String model = iosInfo.model ?? "";
      String os_version = iosInfo.systemVersion.toString();
      String app_version = "1.2.3";
      String device_id = iosInfo.identifierForVendor.toString() + dateTime;
      // String device_id = iosInfo.identifierForVendor.toString() + dateTime ?? "";
      // //debugPrint('Running on ${iosInfo.utsname.machine}');
      return DeviceInfoModel(brand, model, os_version, app_version, device_id);
    }
  }
}

class DeviceInfoModel {
  final String brand;
  final String model;
  final String os_version;
  final String app_version;
  final String device_id;

  DeviceInfoModel(this.brand, this.model, this.os_version, this.app_version, this.device_id);
}
