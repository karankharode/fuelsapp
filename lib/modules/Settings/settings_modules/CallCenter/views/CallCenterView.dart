import 'package:flutter/material.dart';
import 'package:fuelsapp/modules/Auth/EnterNumber/widgets/PrimaryButton.dart';
import 'package:fuelsapp/utils/ColorUtil.dart';
import 'package:url_launcher/url_launcher.dart';

class CallCenterScreen extends StatefulWidget {
  const CallCenterScreen({Key? key}) : super(key: key);

  @override
  State<CallCenterScreen> createState() => _CallCenterScreenState();
}

class _CallCenterScreenState extends State<CallCenterScreen> {
  ColorUtil colorUtil = ColorUtil();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Call Center'),
          elevation: 0,
          backgroundColor: colorUtil.primaryRed,
        ),
        backgroundColor: colorUtil.white,
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                final Uri telLaunch = Uri.parse('tel:80018888');
                launchUrl(telLaunch);
              },
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Image.asset('assets/images/call_center.jpeg'),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: PrimaryButton(
                  btnText: "Call Now",
                  onTap: () {
                    final Uri telLaunch = Uri.parse('tel:80018888');
                    launchUrl(telLaunch);
                    //                final Uri telLaunch =  Uri(
                    // scheme: 'tel',
                    // path: '800-198-88',
                    // query: );
                  }),
            )
          ],
        ));
  }
}
