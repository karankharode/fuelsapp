import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fuelsapp/modules/Auth/Login/model/LoginResponseModel.dart';
import 'package:fuelsapp/modules/HomePage/model/QrPaymentStatusResponse.dart';
import 'package:fuelsapp/modules/HomePage/model/QrResponse.dart';
import 'package:fuelsapp/utils/DeviceInfoUtil.dart';
import 'package:fuelsapp/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:fuelsapp/utils/SharedPrefsUtil.dart';
import 'package:uuid/uuid.dart';

import '../model/WalletResponseModel.dart';

class QRController {
  static final _sharedPref = SharedPref.instance;
  static final _deviceInfo = DeviceInfoUtil.instance;
  var uuid = Uuid();

  Future<QRResponse> generateQr({required String walletId}) async {
    DeviceInfoModel deviceInfoModel = await _deviceInfo.getDeviceInfo();

    LoginResponse loginResponse = await _sharedPref.getUserInfo();
    String trxRefId = uuid.v4().toString();
    String req_id = uuid.v4().toString();
    String brand = deviceInfoModel.brand;
    String model = deviceInfoModel.model;
    String os = deviceInfoModel.os_version;
    String app = deviceInfoModel.app_version;
    String deviceid = deviceInfoModel.device_id;
    String reqby = loginResponse.citizenId;

    var headers = {
      'Authorization': 'Bearer $accessTokenGlobal',
      'x-req-id': req_id,
      'x-brand': brand,
      'x-model': model,
      'x-os-version': os,
      'x-app-version': app,
      'x-device-id': deviceid,
      'x-req-by': reqby
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/api/v1/qr/generate/image?phoneNo=${loginResponse.phone}&trxRefId=$trxRefId&customerId=${loginResponse.customerId}&walletType=DISCOUNT&walletId=$walletId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // //debugPrint("here");
      // //debugPrint(await response.stream.bytesToString());
      // List<int> uint8list = await response.stream.toBytes();
      Uint8List uint8list = await response.stream.toBytes();

      // //debugPrint(uint8list);
      // var uint8list = [];
      // setState(() {});
      return QRResponse(true, trxRefId, uint8list);
      // return {"success": true, "image": uint8list};
    } else {
      //debugPrint("Failed");
      //debugPrint(response.reasonPhrase);
      // //debugPrint(response.reasonPhrase);
      return QRResponse(false, trxRefId, Uint8List.fromList([]));
      // return {"success": false, "image": []};
    }
  }

  Future<WalletResponseModel> getWalletId() async {
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
    // //debugPrint("customer id : ${loginResponse.customerId}");
    // //debugPrint(headers);
    var request =
        http.Request('GET', Uri.parse('$baseUrl/api/v1/wallets/list/${loginResponse.customerId}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // //debugPrint(await response.stream.bytesToString());
      // //debugPrint("Wallet success");

      String responseStream = await response.stream.bytesToString();

      var data = jsonDecode(responseStream);
      // //debugPrint("wallet data : $data");
      SubsidyAccountBalance subsidyAccountBalance =
          SubsidyAccountBalance.fromResponse(data['subsidyAccountBalance']);
      return WalletResponseModel(
        subsidyAccountBalance: subsidyAccountBalance,
        prepaidAccountBalance: data["prepaidAccountBalance"].toString(),
        success: true,
      );
    } else {
      //debugPrint(response.reasonPhrase);
      //debugPrint("Wallet failed");
      return WalletResponseModel(
          subsidyAccountBalance: SubsidyAccountBalance(
              createdAt: "createdAt",
              createdBy: "createdBy",
              updatedAt: "updatedAt",
              updatedBy: "updatedBy",
              id: "id",
              allocatedLiter: "allocatedLiter",
              availableLiter: "availableLiter",
              onholdLiter: "onholdLiter",
              account: "account",
              secureHash: "secureHash"),
          prepaidAccountBalance: "null",
          success: false);
    }
  }

  Future<QrPaymentStatusResponse> getQRPaymentStatus(String trxRefId) async {
    //debugPrint("Checking");
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
    // //debugPrint("customer id : ${loginResponse.customerId}");
    // //debugPrint(headers);
    var request =
        http.Request('GET', Uri.parse('$baseUrl/api/v1/transaction/status/qr?trxRefId=$trxRefId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // //debugPrint(await response.stream.bytesToString());
      // //debugPrint("Wallet success");

      String responseStream = await response.stream.bytesToString();

      var data = jsonDecode(responseStream);
      // //debugPrint("wallet data : $data");
      QrPaymentStatusResponse qrPaymentStatusResponse = QrPaymentStatusResponse.fromResponse(data);
      return qrPaymentStatusResponse;
    } else {
      //debugPrint(response.reasonPhrase);
      //debugPrint("Wallet failed");
      return QrPaymentStatusResponse(
          authorizedLiter: "authorizedLiter",
          balanceLiter: "balanceLiter",
          orgBalanceLiter: "orgBalanceLiter",
          status: "status",
          approvalCode: "approvalCode",
          transactionRef: "transactionRef",
          invoiceId: "invoiceId",
          qrRef: "qrRef",
          customerId: "customerId",
          customerName: "customerName");
    }
  }
}
