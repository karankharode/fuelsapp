import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fuelsapp/modules/Auth/EnterNumber/views/ConfirmPin.dart';
import 'package:fuelsapp/modules/Auth/EnterNumber/widgets/PrimaryButton.dart';
import 'package:fuelsapp/utils/AnimationUtil.dart';
import 'package:fuelsapp/utils/ColorUtil.dart';
import 'package:fuelsapp/utils/ThemeUtil.dart';
import 'package:fuelsapp/utils/customFlushbar.dart';

class CreatePin extends StatefulWidget {
  final String accessToken;
  final String civilId;
  final String phone;
  final String flag;
  const CreatePin({
    Key? key,
    required this.accessToken,
    required this.civilId,
    required this.flag,
    required this.phone,
  }) : super(key: key);

  @override
  _CreatePinState createState() => _CreatePinState();
}

class _CreatePinState extends State<CreatePin> with TickerProviderStateMixin {
  late Size size;
  String pin = '';
  ColorUtil colorUtil = ColorUtil();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startPageLoadAnimations(
      animationsMap.values.where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
  }

  createPin() async {
    if (pin.length != 4) {
      showCustomFlushBar(context, "Enter valid PIN!", 2);
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ConfirmPin(pin: pin, civilId: widget.civilId,
              flag: widget.flag,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return child;
            },
          ));
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
                  "Create a Login PIN",
                  style: ThemeUtil.authTitle1,
                ),
                Text(
                  "رقم تعريف الدخول",
                  style: ThemeUtil.authTitle2,
                ),
                Text(
                  "Please create a login PIN for your account",
                  style: ThemeUtil.authSubTitle1,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "الرجاء تحديد رقم تعريفي الخاص بك",
                    style: ThemeUtil.authSubTitle1,
                  ),
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
                  obscureText: false,

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  borderColor: colorUtil.backgroundColor,
                  focusedBorderColor: colorUtil.primaryRed,
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,

                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    pin = pin + code;
                    //handle validation or checks here
                  },

                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) async {}, // end onSubmit
                )).animated([animationsMap['textFieldOnPageLoadAnimation']!]),
            Spacer(
              flex: 12,
            ),
            PrimaryButton(
                btnText: "Create a Pin",
                onTap: () {
                  createPin();
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
