import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fuelsapp/modules/Auth/Login/model/LoginResponseModel.dart';
import 'package:fuelsapp/utils/DeviceInfoUtil.dart';
import 'package:fuelsapp/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:fuelsapp/utils/SharedPrefsUtil.dart';
import 'package:uuid/uuid.dart';

import '../models/CardListResponse.dart';

class CardController {
  static final _sharedPref = SharedPref.instance;
  static final _deviceInfo = DeviceInfoUtil.instance;
  var uuid = Uuid();

  Future<CardListResponse> getCardList() async {
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
    //debugPrint(headers.toString());
    var request =
        http.Request('GET', Uri.parse('$baseUrl/api/v1/card/list/${loginResponse.customerId}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //debugPrint("Wallet success");

      String responseStream = await response.stream.bytesToString();
      // //debugPrint(responseStream);
      var data = jsonDecode(responseStream);
      // //debugPrint(data);

      CardListResponse cardListResponse = CardListResponse.fromResponse(data);
      _sharedPref.saveCardNumber(cardListResponse.cardList[0].cardNo.toString());
      //debugPrint("object");
      return cardListResponse;
    } else {
      //debugPrint(response.reasonPhrase);
      //debugPrint("card data failed");
      return CardListResponse(cardList: [], success: false);
    }
  }
}
