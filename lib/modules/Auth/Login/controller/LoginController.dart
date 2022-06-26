import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fuelsapp/modules/Auth/Login/model/AuthResponse.dart';
import 'package:fuelsapp/modules/Auth/Login/model/GenerateOtpResponse.dart';
import 'package:fuelsapp/modules/Auth/Login/model/VerifyOtpResponse.dart';
import 'package:fuelsapp/utils/DeviceInfoUtil.dart';
import 'package:fuelsapp/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:fuelsapp/modules/Auth/Login/model/LoginResponseModel.dart';
import 'package:fuelsapp/utils/SharedPrefsUtil.dart';
import 'package:uuid/uuid.dart';

class LoginController {
  static final _sharedPref = SharedPref.instance;
  static final _deviceInfo = DeviceInfoUtil.instance;
  var uuid = Uuid();
  Future<bool> isUserAuthorized() async {
    // return false;
    return await SharedPref.instance.readIsLoggedIn();
  }

  Future<LoginResponse> getSavedUserDetails() async {
    String data = await _sharedPref.getUser();
    //debugPrint('User Data ahead:');
    //debugPrint("Data from prefs : " + data);
    LoginResponse loginResponse = new LoginResponse.fromJson(json.decode(data));
    return loginResponse;
  }

  Future<AuthResponse> doAuthentication() async {
    DeviceInfoModel deviceInfoModel = await _deviceInfo.getDeviceInfo();
    var headers = {
      'x-req-id': uuid.v1().toString(),
      'x-brand': deviceInfoModel.brand,
      'x-model': deviceInfoModel.model,
      'x-os-version': deviceInfoModel.os_version,
      'x-app-version': deviceInfoModel.app_version,
      'x-device-id': deviceInfoModel.device_id,
      // 'x-req-by': '+66${loginResponse.citizenId}',
      'Content-Type': 'text/plain'
    };
    var request = http.Request('POST', Uri.parse('$baseUrl/api/v1/auth/signin'));
    request.body =
        '''{\r\n    "username": "mobileapi",\r\n    "password": "Mobile@FuelPay#22"\r\n}''';
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseStream = await response.stream.bytesToString();
        var data = jsonDecode(responseStream);
        String accessToken = data['accessToken'];
        //debugPrint(accessToken);
        accessTokenGlobal = accessToken;
        AuthResponse authResponse = AuthResponse(accessToken: accessToken, statusCode: 200);
        return authResponse;
      } else {
        //debugPrint(response.reasonPhrase);
        return AuthResponse(accessToken: "", statusCode: response.statusCode);
      }
    } catch (e) {
      return AuthResponse(accessToken: "", statusCode: 400);
    }
  }

  Future<LoginByRegisterIdResponse> loginByRegisteredUser(String pin) async {
    DeviceInfoModel deviceInfoModel = await _deviceInfo.getDeviceInfo();
    LoginResponse loginResponse = await _sharedPref.getUserInfo();
    var headers = {
      'x-req-id': uuid.v1().toString(),
      'x-brand': deviceInfoModel.brand,
      'x-model': deviceInfoModel.model,
      'x-os-version': deviceInfoModel.os_version,
      'x-app-version': deviceInfoModel.app_version,
      'x-device-id': deviceInfoModel.device_id,
      'x-req-by': '+66${loginResponse.citizenId}',
      'Content-Type': 'text/plain'
    };
    //debugPrint("Login by registered user headers : $headers");

    var request = http.Request('POST', Uri.parse('$baseUrl/api/v1/auth/signin'));
    request.body =
        '''{\r\n    "username": "${loginResponse.customerId}",\r\n    "password": "$pin"\r\n}''';
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        //debugPrint("login success");
        String responseStream = await response.stream.bytesToString();
        var data = jsonDecode(responseStream);
        //debugPrint("data : $data");
        String accessToken = data['accessToken'];
        //debugPrint(accessToken);
        accessTokenGlobal = accessToken;

        await _sharedPref.saveIsLoggedIn(true);
        LoginByRegisterIdResponse loginByRegisterIdResponse = LoginByRegisterIdResponse(
            accessToken: accessToken, statusCode: 200, statusPhrase: "Success");
        return loginByRegisterIdResponse;
      } else {
        //debugPrint(response.reasonPhrase);
        return LoginByRegisterIdResponse(
            accessToken: "", statusCode: response.statusCode, statusPhrase: "Error Occured!");
      }
    } catch (e) {
      return LoginByRegisterIdResponse(
          accessToken: "", statusCode: 400, statusPhrase: "Error Occured!");
    }
  }

  Future<GenerateOTPResponse> verifyCivilId(String civilId, String flag) async {
    DeviceInfoModel deviceInfoModel = await _deviceInfo.getDeviceInfo();
    var headers = {
      'Authorization': 'Bearer $accessTokenGlobal',
      'Content-Type': 'application/json',
      'x-req-id': uuid.v1().toString(),
      'x-brand': deviceInfoModel.brand,
      'x-model': deviceInfoModel.model,
      'x-os-version': deviceInfoModel.os_version,
      'x-app-version': deviceInfoModel.app_version,
      'x-device-id': deviceInfoModel.device_id,
      'x-req-by': '+66$civilId'
    };

    try {
      var request =
          http.Request('GET', Uri.parse('$baseUrl/api/v1/customers/verify/$civilId')); //656729644

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseStream = await response.stream.bytesToString();
        //debugPrint(responseStream);
        var data = jsonDecode(responseStream);
        //debugPrint("verify by civil id data : $data ");
        String phone = data['phone'];
        // LoginResponse loginResponse =
        //     LoginResponse.getUserDetailsLoginResponseFromHttpResponse(data);

        _sharedPref.saveUser(responseStream);
        if (data['flow'] == "EXISTING") {
          if (flag == "pinChange") {
            GenerateOTPResponse generateOTPResponse = await otpGenerate(data['citizenId'], phone);
            return GenerateOTPResponse(
                otpMobileNo: generateOTPResponse.otpMobileNo,
                phone: generateOTPResponse.phone,
                flow: "EXISTING",
                otpRef: generateOTPResponse.otpRef,
                otpSent: generateOTPResponse.otpSent,
                civilNumberVerified: generateOTPResponse.civilNumberVerified);
          }
          return GenerateOTPResponse(
              otpMobileNo: "otpMobileNo",
              phone: phone,
              flow: "EXISTING",
              otpRef: "otpRef",
              otpSent: false,
              civilNumberVerified: true);
        } else {
          //debugPrint("here");
          GenerateOTPResponse generateOTPResponse = await otpGenerate(data['citizenId'], phone);
          //debugPrint("here");
          return generateOTPResponse;
        }
      } else {
        //debugPrint(response.reasonPhrase);
        return GenerateOTPResponse(
            otpMobileNo: 'otpMobileNo',
            flow: "NULL",
            phone: " ",
            otpRef: 'otpRef',
            otpSent: false,
            civilNumberVerified: false);
      }
    } catch (e) {
      //debugPrint("Error");
      //debugPrint(e.toString());
      return GenerateOTPResponse(
          otpMobileNo: 'otpMobileNo',
          phone: '',
          flow: "NULL",
          otpRef: 'otpRef',
          otpSent: false,
          civilNumberVerified: false);
    }
  }

  Future<RegisterUserResponse> registerUser(String civilId, String pin) async {
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
      'x-req-by': '+66$civilId'
    };
    //debugPrint("register header : $headers");

    try {
      var request = http.Request('POST', Uri.parse('$baseUrl/api/v1/user/create'));
      request.body = json.encode({
        "customerId": loginResponse.customerId,
        "password": pin,
        "phone": loginResponse.phone,
        "email": loginResponse.email,
        "userType": "MOBILE",
        "username": loginResponse.customerId,
        "fcmToken": "124",
        "deviceId": deviceInfoModel.device_id,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      /*
      {
    "username": "MOG104933591",
    "password": "1111",
    "token": null,
    "email": "",
    "phone": "+66656729644",
    "customerId": "MOG104933591",
    "userType": "MOBILE",
    "active": null,
    "credsExpired": null,
    "locked": null,
    "deleted": null,
    "verified": null,
    "expiry": null,
    "forcePasswordChange": null,
    "lastLogin": null,
    "passwordChanged": null,
    "loginAttempts": null,
    "deviceId": "125",
    "fcmToken": "124"
}
      */

      //debugPrint(" register response  : ${response.statusCode}");
      if (response.statusCode == 201) {
        String responseStream = await response.stream.bytesToString();
        //debugPrint(responseStream);

        return RegisterUserResponse(status: true);
      } else {
        //debugPrint(response.reasonPhrase);
        return RegisterUserResponse(status: false);
      }
    } catch (e) {
      //debugPrint("Error");
      //debugPrint(e.toString());
      return RegisterUserResponse(status: false);
    }
  }

  Future<GenerateOTPResponse> otpGenerate(String citizenId, String phone) async {
    DeviceInfoModel deviceInfoModel = await _deviceInfo.getDeviceInfo();
    LoginResponse loginResponse = await _sharedPref.getUserInfo();
    //debugPrint(loginResponse.citizenId);
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
    try {
      var request = http.Request('POST', Uri.parse('$baseUrl/api/v1/otp/generate'));
      request.body = json.encode({"citizenId": citizenId});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseStream = await response.stream.bytesToString();

        //debugPrint(responseStream);
        var data = jsonDecode(responseStream);
        return GenerateOTPResponse(
            otpMobileNo: data['otpMobileNo'],
            flow: "NEW",
            phone: phone,
            otpRef: data['otpRef'],
            otpSent: true,
            civilNumberVerified: true);
      } else {
        //debugPrint(response.reasonPhrase);
        return GenerateOTPResponse(
            otpMobileNo: 'otpMobileNo',
            otpRef: 'otpRef',
            flow: "NEW",
            phone: phone,
            otpSent: true,
            civilNumberVerified: true);
      }
    } catch (e) {
      return GenerateOTPResponse(
          otpMobileNo: 'otpMobileNo',
          otpRef: 'otpRef',
          flow: "NEW",
          phone: phone,
          otpSent: true,
          civilNumberVerified: true);
    }
  }

  Future<VerifyOTPResponse> verifyOtp(String otp, String otpRef) async {
    DeviceInfoModel deviceInfoModel = await _deviceInfo.getDeviceInfo();
    LoginResponse loginResponse = await _sharedPref.getUserInfo();
    var headers = {
      'Authorization': 'Bearer ${accessTokenGlobal}',
      'Content-Type': 'application/json',
      'x-req-id': uuid.v1().toString(),
      'x-brand': deviceInfoModel.brand,
      'x-model': deviceInfoModel.model,
      'x-os-version': deviceInfoModel.os_version,
      'x-app-version': deviceInfoModel.app_version,
      'x-device-id': deviceInfoModel.device_id,
      'x-req-by': '+66${loginResponse.citizenId}'
    };

    try {
      var request = http.Request('POST', Uri.parse('$baseUrl/api/v1/otp/verify'));
      request.body = json.encode({"otpPassword": otp, "otpRef": otpRef});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseStream = await response.stream.bytesToString();
        //debugPrint(responseStream);
        var data = jsonDecode(responseStream);

        // //debugPrint(await response.stream.bytesToString());
        if (data['status'] == "VERIFIED") {
          return VerifyOTPResponse(verified: true);
        } else {
          return VerifyOTPResponse(verified: false);
        }
      } else {
        //debugPrint(response.reasonPhrase);
        return VerifyOTPResponse(verified: false);
      }
    } catch (e) {
      return VerifyOTPResponse(verified: false);
    }
  }

  Future<RegisterUserResponse> createPin(String pin, String civilId) async {
    try {
      // await _sharedPref.saveUserLoginPin(pin);
      RegisterUserResponse registerUserResponse = await registerUser(civilId, pin);
      if (registerUserResponse.status) {
        await _sharedPref.saveIsLoggedIn(true);
      }
      return registerUserResponse;
    } catch (e) {
      return RegisterUserResponse(status: false);
    }
  }

  Future<bool> updatePin(String pin, String civilId) async {
    DeviceInfoModel deviceInfoModel = await _deviceInfo.getDeviceInfo();
    LoginResponse loginResponse = await _sharedPref.getUserInfo();
    //debugPrint(loginResponse.customerId);

    var headers = {
      'Authorization': 'Bearer ${accessTokenGlobal}',
      'x-req-id': uuid.v1().toString(),
      'x-brand': deviceInfoModel.brand,
      'x-model': deviceInfoModel.model,
      'x-os-version': deviceInfoModel.os_version,
      'x-app-version': deviceInfoModel.app_version,
      'x-device-id': deviceInfoModel.device_id,
      'x-req-by': '+66$civilId',
      'Content-Type': 'application/json'
    };
    //debugPrint(headers.toString());

    var request = http.Request('PUT', Uri.parse('$baseUrl/api/v1/user/update'));
    request.body = json.encode({"username": loginResponse.customerId, "password": pin});
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      //debugPrint(response.statusCode.toString());

      //debugPrint(await response.stream.bytesToString());

      if (response.statusCode == 201) {
        //debugPrint("true");
        return true;
      } else {
        //debugPrint(response.reasonPhrase);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> logOut() {
    _sharedPref.removeUser();
    return _sharedPref.removeIsLoggedIn();
  }
}
