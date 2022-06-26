import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fuelsapp/modules/Auth/EnterNumber/widgets/PrimaryButton.dart';
import 'package:fuelsapp/modules/HomePage/views/HomePageView.dart';
import 'package:fuelsapp/utils/AnimationUtil.dart';
import 'package:fuelsapp/utils/ColorUtil.dart';
import 'package:fuelsapp/utils/SharedPrefsUtil.dart';
import 'package:fuelsapp/utils/ThemeUtil.dart';
import 'package:fuelsapp/utils/customFlushbar.dart';

import '../../../../utils/common.dart';
import '../../Login/controller/LoginController.dart';
import '../../Login/model/AuthResponse.dart';
import 'EnterNumber.dart';

class VerifyPin extends StatefulWidget {
  const VerifyPin({
    Key? key,
  }) : super(key: key);

  @override
  _VerifyPinState createState() => _VerifyPinState();
}

class _VerifyPinState extends State<VerifyPin> with TickerProviderStateMixin {
  late Size size;
  String pin = '';
  String savedPin = '';
  ColorUtil colorUtil = ColorUtil();
  static final _sharedPref = SharedPref.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startPageLoadAnimations(
      animationsMap.values.where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
    // doAuthentication();
  }

  Future<LoginByRegisterIdResponse> doAuthentication() async {
    LoginByRegisterIdResponse loginByRegisterIdResponse =
        await LoginController().loginByRegisteredUser(pin);
    if (loginByRegisterIdResponse.statusCode == 200) {
      setState(() {
        accessTokenGlobal = loginByRegisterIdResponse.accessToken;
      });
    }
    return loginByRegisterIdResponse;
  }

  verifyLoginPin() async {
    // savedPin = await _sharedPref.getLoginPin();
    // //debugPrint(savedPin);
    // //debugPrint(pin);
    if (pin.length != 4) {
      showCustomFlushBar(context, "Enter valid PIN!", 2);
    } else {
      LoginByRegisterIdResponse loginByRegisterIdResponse = await doAuthentication();
      if (loginByRegisterIdResponse.statusCode == 200) {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => HomePageView(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return child;
              },
            ));
      } else {
        showCustomFlushBar(context, "Pin does not match!", 2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        // leading: Icon(
        //   Icons.arrow_back,
        //   color: Colors.black,
        // ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(
              flex: 1,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter your Login PIN",
                  style: ThemeUtil.authTitle1,
                ),
                // Text(
                //   "رقم تعريف الدخول",
                //   style: ThemeUtil.authTitle2,
                // ),
                Text(
                  "Please enter the login PIN you created for your account",
                  style: ThemeUtil.authSubTitle1,
                ),
                Text(
                  "الرجاء إدخال الرقم التعريفي الخاص بك",
                  style: ThemeUtil.authSubTitle1,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0),
                //   child: Text(
                //     "الرجاء تحديد رقم تعريفي الخاص بك",
                //     style: ThemeUtil.authSubTitle1,
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
              ],
            ).animated([animationsMap['textOnPageLoadAnimation']!]),
            const Spacer(
              flex: 1,
            ),
            Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 5),
                child: OtpTextField(
                  numberOfFields: 4,
                  autoFocus: true,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  cursorColor: colorUtil.primaryRed,
                  fillColor: colorUtil.white,
                  filled: true,
                  borderWidth: 1,
                  disabledBorderColor: colorUtil.backgroundColor,
                  fieldWidth: size.width / 6,
                  obscureText: true,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  borderColor: colorUtil.backgroundColor,
                  focusedBorderColor: colorUtil.primaryRed,
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,

                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    // if (pin != "") {
                    //   pin = pin + code;
                    // } else {}
                    //handle validation or checks here
                  },

                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) async {
                    pin = verificationCode;
                    // verifyLoginPin();
                  }, // end onSubmit
                )).animated([animationsMap['textFieldOnPageLoadAnimation']!]),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const EnterNumber(
                          flag: "pinChange",
                        ),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                      ),
                      (route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "Reset Pin!",
                    style: ThemeUtil.authSubTitle1.copyWith(color: ColorUtil().primaryRed),
                  ),
                ),
              ),
            ),
            Spacer(
              flex: 12,
            ),
            PrimaryButton(
                btnText: "Verify",
                onTap: () {
                  verifyLoginPin();
                }),
            Spacer(
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
