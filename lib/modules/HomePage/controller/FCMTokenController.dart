import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fuelsapp/modules/Auth/Login/model/LoginResponseModel.dart';
import 'package:fuelsapp/utils/DeviceInfoUtil.dart';
import 'package:fuelsapp/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:fuelsapp/utils/SharedPrefsUtil.dart';
import 'package:uuid/uuid.dart';

import '../model/UpdateFCMTokenResponse.dart';

class FCMTokenController {
  static final _sharedPref = SharedPref.instance;
  static final _deviceInfo = DeviceInfoUtil.instance;
  var uuid = const Uuid();

  Future<UpdateFCMTokenResponse> updateFCMToken(String fcmToken) async {
    DeviceInfoModel deviceInfoModel = await _deviceInfo.getDeviceInfo();

    LoginResponse loginResponse = await _sharedPref.getUserInfo();
    var headers = {
      'Authorization': 'Bearer $accessTokenGlobal',
      'Content-Type': 'application/json',
      'x-req-id': uuid.v1().toString(),
      'x-brand': deviceInfoModel.brand,
      'x-model': deviceInfoModel.model,
      'x-os-version': deviceInfoModel.os_version,
      'x-app-version': deviceInfoModel.app_version,
      'x-device-id': deviceInfoModel.device_id,
      'x-req-by': '+66${loginResponse.citizenId}'
    };

    var request = http.Request('POST', Uri.parse('$baseUrl/api/v1/device/update/fcm'));
    request.body = json.encode({
      "customerId": loginResponse.customerId,
      "fcmToken": fcmToken,
      "deviceId": deviceInfoModel.device_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // //debugPrint(await response.stream.bytesToString());
      // //debugPrint("Wallet success");

      String responseStream = await response.stream.bytesToString();

      var data = jsonDecode(responseStream);
      // //debugPrint("wallet data : $data");
      return UpdateFCMTokenResponse(true, data['code'], data['message']);
    } else {
      //debugPrint(response.reasonPhrase);
      //debugPrint("Wallet failed");
      return UpdateFCMTokenResponse(false, "865", "Error");
    }
  }
}
