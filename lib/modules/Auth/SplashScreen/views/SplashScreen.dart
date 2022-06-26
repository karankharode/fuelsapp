import 'package:flutter/material.dart';
import 'package:fuelsapp/modules/Auth/EnterNumber/views/EnterNumber.dart';
import 'package:fuelsapp/modules/Auth/EnterNumber/views/VerifyPin.dart';
import 'package:fuelsapp/modules/Auth/Login/controller/LoginController.dart';
// import 'package:fuelsapp/modules/Auth/Login/model/LoginResponseModel.dart';

/// Component UI
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// Component UI
class _SplashScreenState extends State<SplashScreen> {
  /// Setting duration in splash screen
  // startTime() async {
  //   return new Timer(Duration(milliseconds: 3000), NavigatorPage);
  // }
  checkLogin() async {
    final loginController = LoginController();

    var defaultPage;

    bool isAuthorized = await loginController.isUserAuthorized();
    if (isAuthorized) {
      // LoginResponse loginResponse = await loginController.getSavedUserDetails();

      defaultPage = const VerifyPin();
    } else {
      defaultPage = const EnterNumber(flag: "login");
    }
    Widget defaultHome = defaultPage;
    navigatorPage(defaultHome); // isAuthorized ? homePage : loginPage;
  }

  /// To navigate layout change
  void navigatorPage(startupPage) {
    Navigator.of(context)
        .pushReplacement(PageRouteBuilder(pageBuilder: (_, __, ___) => startupPage));
  }

  /// Declare startTime to InitState
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  /// Code Create UI Splash Screen
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: _height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFAC327), Color(0xffEF941E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // color: Color(0xffF13728),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(75.0),
          child: Image.asset("assets/branding/icon_transparent.png"),
        )),
      ),
    );
  }
}
