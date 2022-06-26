import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fuelsapp/modules/Auth/EnterNumber/views/CreatePin.dart';
import 'package:fuelsapp/modules/Auth/EnterNumber/widgets/PrimaryButton.dart';
import 'package:fuelsapp/modules/Auth/Login/controller/LoginController.dart';
import 'package:fuelsapp/modules/Auth/Login/model/VerifyOtpResponse.dart';
import 'package:fuelsapp/utils/AnimationUtil.dart';
import 'package:fuelsapp/utils/ColorUtil.dart';
import 'package:fuelsapp/utils/ThemeUtil.dart';
import 'package:fuelsapp/utils/customFlushbar.dart';
import 'package:provider/provider.dart';

class VerifyNumber extends StatefulWidget {
  final String otpRef;
  final String accessToken;
  final String civilId;
  final String otpMobileNo;
  final String phone;
  final String flag;
  const VerifyNumber(
      {Key? key,
      required this.otpRef,
      required this.accessToken,
      required this.civilId,
      required this.otpMobileNo,
      required this.flag,
      required this.phone})
      : super(key: key);

  @override
  _VerifyNumberState createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> with TickerProviderStateMixin {
  late Size size;
  String otp = '';
  ColorUtil colorUtil = ColorUtil();
  late LoginController loginController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startPageLoadAnimations(
      animationsMap.values.where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
  }

  verifyOtp() async {
    VerifyOTPResponse verifyOTPResponse = await loginController.verifyOtp(otp, widget.otpRef);
    if (verifyOTPResponse.verified) {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => CreatePin(
                flag: widget.flag,
                accessToken: widget.accessToken,
                civilId: widget.civilId,
                phone: widget.phone),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return child;
            },
          ));
    } else {
      showCustomFlushBar(context, "OTP is incorrect", 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    loginController = Provider.of<LoginController>(context);
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
            Spacer(
              flex: 1,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Verification Number",
                  style: ThemeUtil.authTitle1,
                ),
                Text(
                  "رقم التأكيد",
                  style: ThemeUtil.authTitle2,
                ),
                Text(
                  "Please enter the OTP number sent to your registered Mobile Number",
                  style: ThemeUtil.authSubTitle1,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "الرجاء ادخال رمز التأكيد المرسل لرقم الهاتف المسجل",
                    style: ThemeUtil.authSubTitle1,
                  ),
                ),
              ],
            ).animated([animationsMap['textOnPageLoadAnimation']!]),
            Spacer(
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
                  // onCodeChanged: (String code) {
                  //   otp = otp + code;
                  //   //handle validation or checks here
                  // },

                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) async {
                    otp = verificationCode;
                  }, // end onSubmit
                )).animated([animationsMap['textFieldOnPageLoadAnimation']!]),
            // Text(
            //   "Otp send to mobile : ${widget.otpMobileNo}",
            //   style: ThemeUtil.authSubTitle1,
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Text(
                    "   Resend  ",
                    style: ThemeUtil.authTitle1.copyWith(
                        color: colorUtil.primaryRed, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: colorUtil.primaryRed,
                    size: 12,
                  ),
                ],
              ),
            ).animated([animationsMap['textFieldOnPageLoadAnimation']!]),
            Spacer(
              flex: 12,
            ),
            PrimaryButton(
                btnText: "Verify",
                onTap: () {
                  verifyOtp();
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
