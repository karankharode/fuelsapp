import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fuelsapp/modules/Auth/EnterNumber/views/VerifyNumber.dart';
import 'package:fuelsapp/modules/Auth/EnterNumber/views/VerifyPin.dart';
import 'package:fuelsapp/modules/Auth/EnterNumber/widgets/PrimaryButton.dart';
import 'package:fuelsapp/modules/Auth/Login/controller/LoginController.dart';
import 'package:fuelsapp/modules/Auth/Login/model/AuthResponse.dart';
import 'package:fuelsapp/modules/Auth/Login/model/GenerateOtpResponse.dart';
import 'package:fuelsapp/utils/AnimationUtil.dart';
import 'package:fuelsapp/utils/ThemeUtil.dart';
import 'package:fuelsapp/utils/common.dart';
import 'package:fuelsapp/utils/customFlushbar.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart' as location;

class EnterNumber extends StatefulWidget {
  const EnterNumber({Key? key, required this.flag}) : super(key: key);
  final String flag; // "login" "pinChange"

  @override
  _EnterNumberState createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> with TickerProviderStateMixin {
  late Size size;
  String civilId = "";
  final location.Location _location = location.Location();

  // String phone = "";
  final _civilIdFormKey = GlobalKey<FormState>();
  late LoginController loginController;
  @override
  void initState() {
    super.initState();
    printToken();
    startPageLoadAnimations(
      animationsMap.values.where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
    getPermission();
    doAuthentication();
  }

  getPermission() async {
    await _location.requestPermission();
    if (!await _location.serviceEnabled()) {
      await _location.requestService();
    }
  }

  doAuthentication() async {
    AuthResponse authResponse = await LoginController().doAuthentication();
    if (authResponse.statusCode == 200) {
      setState(() {
        accessTokenGlobal = authResponse.accessToken;
      });
    }
  }

  printToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    //debugPrint("Token : " + token.toString());
  }

  verifyCivilId() async {
    GenerateOTPResponse generateOTPResponse =
        await loginController.verifyCivilId(civilId.trim(), widget.flag);
    if (widget.flag == "pinChange") {
      if (generateOTPResponse.civilNumberVerified) {
        if (generateOTPResponse.otpSent) {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => VerifyNumber(
                    accessToken: accessTokenGlobal,
                    civilId: civilId,
                    flag: widget.flag,
                    otpRef: generateOTPResponse.otpRef,
                    otpMobileNo: generateOTPResponse.otpMobileNo,
                    phone: generateOTPResponse.phone),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return child;
                },
              ));
        } else {
          showCustomFlushBar(context, "OTP not sent", 2);
        }
      } else {
        showCustomFlushBar(context, "Civil Number not verified", 2);
      }
    } else {
      if (generateOTPResponse.flow == "EXISTING") {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const VerifyPin(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return child;
              },
            ));
      } else {
        if (generateOTPResponse.civilNumberVerified) {
          if (generateOTPResponse.otpSent) {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => VerifyNumber(
                      accessToken: accessTokenGlobal,
                      civilId: civilId,
                      flag: widget.flag,
                      otpRef: generateOTPResponse.otpRef,
                      otpMobileNo: generateOTPResponse.otpMobileNo,
                      phone: generateOTPResponse.phone),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                ));
          } else {
            showCustomFlushBar(context, "OTP not sent", 2);
          }
        } else {
          showCustomFlushBar(context, "Civil Number not verified", 2);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loginController = Provider.of<LoginController>(context);
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      // ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(
              flex: 3,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter National ID Number",
                  style: ThemeUtil.authTitle1,
                ),
                Text(
                  "الرجاء إدخال رقم البطاقة الشخصية",
                  style: ThemeUtil.authTitle2,
                ),
                // Text(
                //   "Lorem ipsum dolor sit amet, consectetur \nadipiscing elit.",
                //   style: ThemeUtil.authSubTitle1,
                // ),
              ],
            ).animated([animationsMap['textOnPageLoadAnimation']!]),
            Spacer(
              flex: 1,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xffE8E8E8).withOpacity(0.5),
              ),
              child: Row(
                children: <Widget>[
                  Form(
                    key: _civilIdFormKey,
                    child: Expanded(
                      child: TextFormField(
                        onChanged: (value) => civilId = value,
                        keyboardType: TextInputType.number,
                        // validator: (value) => value!.length<10?"Enter valid National ID Number":null,
                        decoration: InputDecoration(
                            hintStyle: ThemeUtil.authHintText,
                            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                            border: InputBorder.none,
                            hintText: "eg. 656729644"),
                      ),
                    ),
                  )
                ],
              ),
            ).animated([animationsMap['textFieldOnPageLoadAnimation']!]),
            // Text("Demo Number : 656729644"),
            Spacer(
              flex: 11,
            ),
            PrimaryButton(
                btnText: "Next",
                onTap: () {
                  verifyCivilId();
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
