import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fuelsapp/modules/Auth/Login/model/LoginResponseModel.dart';
import 'package:fuelsapp/modules/Stations/models/StationListResponse.dart';
import 'package:fuelsapp/utils/DeviceInfoUtil.dart';
import 'package:fuelsapp/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:fuelsapp/utils/SharedPrefsUtil.dart';
import 'package:uuid/uuid.dart';

class StationListController {
  static final _sharedPref = SharedPref.instance;
  static final _deviceInfo = DeviceInfoUtil.instance;
  var uuid = Uuid();

  Future<StationListResponse> getStationList() async {
    DeviceInfoModel deviceInfoModel = await _deviceInfo.getDeviceInfo();

    LoginResponse loginResponse = await _sharedPref.getUserInfo();

    var headers = {
      'Authorization': 'Bearer $accessTokenGlobal',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse('$baseUrl/api/v1/station/list?page=0&size=15'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // //debugPrint(await response.stream.bytesToString());
      // //debugPrint("Wallet success");

      String responseStream = await response.stream.bytesToString();

      var data = jsonDecode(responseStream);
      debugPrint("Station List : " + data.toString());

      StationListResponse stationListResponse = StationListResponse.fromResponse(data['content']);

      return stationListResponse;
    } else {
      //debugPrint(response.reasonPhrase);
      //debugPrint("station data failed");
      return StationListResponse(stationList: [], success: false);
    }
  }
}
