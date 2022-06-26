import 'dart:convert';

import 'package:fuelsapp/modules/Auth/Login/model/LoginResponseModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String _isLoggedInKey = "isLoggedIn";
  static const String _accessTokenKey = "accessToken";
  static const String userLoginPin = "userLoginPin";
  static const String _userInfo = "userInfo";
  static const String _cardNumber = "cardNumber";
  static final SharedPref instance = SharedPref._instantiate();

  SharedPref._instantiate();

  readIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_isLoggedInKey) == null)
      return false;
    else
      return prefs.getBool(_isLoggedInKey);
  }

  Future<LoginResponse> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = json.decode(prefs.getString(_userInfo)!);
    return LoginResponse.fromJson(map);
  }

  Future<String> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey)!;
  }

  Future<String> getLoginPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userLoginPin)!;
  }
  Future<String> getCardNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cardNumber)!;
  }

  saveIsLoggedIn(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isLoggedInKey, value);
  }

  saveUserAccessToken(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_accessTokenKey, value);
  }

  saveUserLoginPin(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userLoginPin, value);
  }
  saveCardNumber(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_cardNumber, value);
  }

  saveUser(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userInfo, value.toString());
  }

  Future<String> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userInfo)!;
  }

  Future<bool> removeIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_isLoggedInKey);
  }

  Future<bool> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_userInfo);
  }

  Future<bool> removeAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_accessTokenKey);
  }
}
