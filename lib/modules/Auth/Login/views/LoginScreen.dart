
import 'package:flutter/material.dart';
import 'package:fuelsapp/modules/Auth/EnterNumber/widgets/PrimaryButton.dart';

import '../../../common/widgets/InputwithIconWidget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _pageState = 0;

  var _backgroundColor = Color(0xffB42219);
  var _headingColor = Colors.white;

  double _headingTop = 100;

  double _loginWidth = 0;
  double _loginHeight = 0;
  double _loginOpacity = 1;

  double _loginYOffset = 0;
  double _loginXOffset = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    setTimerForAnimation();
  }

  setTimerForAnimation() async {
    await Future.delayed(
      Duration(milliseconds: 400),
      () {
        setState(() {
          if (_pageState != 0) {
            _pageState = 0;
          } else {
            _pageState = 1;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight - 200;

    switch (_pageState) {
      case 0:
        _headingColor = Colors.white;

        _headingTop = 100;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = windowHeight;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 140;

        _loginXOffset = 0;
        break;
      case 1:
        _headingColor = Colors.white;

        _headingTop = 70;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = _keyboardVisible ? 40 : 140;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 140;

        _loginXOffset = 0;
        break;
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedContainer(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 400),
              color: _backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: AnimatedContainer(
                      width: double.infinity,
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: Duration(milliseconds: 1000),
                      child: Center(
                        child: Row(
                          children: [
                            Container(
                              height: 260,
                              width: (_loginWidth / 433) * 266,
                              padding: EdgeInsets.only(top: _headingTop, left: 20),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      alignment: Alignment.topLeft,
                                      image: AssetImage("assets/images/login_top_triangle.png"))),
                              child: Text(
                                "Logo ",
                                style: TextStyle(
                                    color: _headingColor,
                                    fontSize: 32,
                                    fontFamily: "Sofia",
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            Spacer()
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          AnimatedContainer(
            padding: EdgeInsets.all(32),
            width: _loginWidth,
            height: _loginHeight,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            transform: Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(_loginOpacity),
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Welcome Back! ",
                      style:
                          TextStyle(fontSize: 26, fontFamily: "Sofia", fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Sign in to your account",
                      style:
                          TextStyle(fontSize: 16, fontFamily: "Sofia", fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
                InputWithIcon(
                  icon: "sms",
                  hint: "Enter Email...",
                ),
                SizedBox(
                  height: 20,
                ),
                InputWithIcon(
                  icon: "lock",
                  hint: "Enter Password...",
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Forgot Password?",
                      style:
                          TextStyle(fontSize: 14, fontFamily: "Sofia", fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    PrimaryButton(
                        btnText: "Sign In",
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     PageRouteBuilder(
                          //       pageBuilder: (context, animation, secondaryAnimation) =>
                          //           const HomePageView(),
                          //       transitionsBuilder:
                          //           (context, animation, secondaryAnimation, child) {
                          //         return child;
                          //       },
                          //     ));
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: OutlineBtn(
                        btnText: "Create New Account",
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class OutlineBtn extends StatefulWidget {
  final String btnText;
  OutlineBtn({required this.btnText});

  @override
  _OutlineBtnState createState() => _OutlineBtnState();
}

class _OutlineBtnState extends State<OutlineBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xffF7961E), borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
