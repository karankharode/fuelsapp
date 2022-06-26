import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fuelsapp/modules/Auth/EnterNumber/widgets/PrimaryButton.dart';
import 'package:fuelsapp/modules/HomePage/views/HomePageView.dart';
import 'package:fuelsapp/utils/AnimationUtil.dart';
import 'package:fuelsapp/utils/ColorUtil.dart';
import 'package:fuelsapp/utils/SharedPrefsUtil.dart';
import 'package:fuelsapp/utils/ThemeUtil.dart';
import 'package:fuelsapp/utils/customFlushbar.dart';
import '../../Login/controller/LoginController.dart';
import '../../Login/model/AuthResponse.dart';
import '../../Login/model/GenerateOtpResponse.dart';

class ConfirmPin extends StatefulWidget {
  const ConfirmPin({
    Key? key,
    required this.pin,
    required this.civilId,
    required this.flag,
  }) : super(key: key);
  final String pin;
  final String civilId;
  final String flag;

  @override
  _ConfirmPinState createState() => _ConfirmPinState();
}

class _ConfirmPinState extends State<ConfirmPin> with TickerProviderStateMixin {
  late Size size;
  String pin = '';
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
  }

  verifyLoginPin() async {
    //debugPrint(pin);
    if (pin.length != 4) {
      showCustomFlushBar(context, "Enter valid PIN!", 2);
    } else {
      if (widget.pin == pin) {
        bool status = false;
        if (widget.flag == "pinChange") {
          bool loginByRegisterIdResponse = await LoginController().updatePin(pin, widget.civilId);
          status = loginByRegisterIdResponse;
        } else {
          RegisterUserResponse createPinResponse =
              await LoginController().createPin(pin, widget.civilId);
          status = createPinResponse.status;
        }

        if (status) {
          LoginByRegisterIdResponse loginByRegisterIdResponse =
              await LoginController().loginByRegisteredUser(pin);
          if (loginByRegisterIdResponse.statusCode == 200) {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const HomePageView(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                ));
          } else {
            showCustomFlushBar(context, "Account created but unable to login!", 2);
          }
        } else {
          showCustomFlushBar(context,
              widget.flag == "pinChange" ? "Pin could not be changed" : "Account not created!", 2);
        }
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
                  "Confirm your Login PIN",
                  style: ThemeUtil.authTitle1,
                ),
                // Text(
                //   "رقم تعريف الدخول",
                //   style: ThemeUtil.authTitle2,
                // ),
                Text(
                  "Please confirm the login PIN you entered in previous screen for your account",
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
