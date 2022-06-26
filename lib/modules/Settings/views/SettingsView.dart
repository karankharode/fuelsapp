import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuelsapp/modules/Auth/EnterNumber/views/EnterNumber.dart';
import 'package:fuelsapp/modules/Auth/Login/controller/LoginController.dart';
import 'package:fuelsapp/modules/Settings/settings_modules/CallCenter/views/CallCenterView.dart';
import 'package:fuelsapp/utils/ColorUtil.dart';
import 'package:path_provider/path_provider.dart';

import '../settings_modules/TermsAndConditions/views/TermsAndConditionsScreen.dart';

class SettingsView extends StatefulWidget {
  SettingsView();

  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String pathPDF = "";

  @override
  void initState() {
    super.initState();
    fromAsset('assets/Terms_Eng.pdf', 'terms_fuelspay.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
    fromAsset('assets/Terms_Arabic.pdf', 'terms_fuelspay.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  static var _txtCustomHead = TextStyle(
    color: Colors.black54,
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
  );

  static var _txtCustomSub = TextStyle(
    color: Colors.black38,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
  );

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe8e8e8).withOpacity(0.3),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ///
                /// Create wave appbar
                ///
                ClipPath(
                  child: Container(
                    height: 160.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        ColorUtil().primaryRed,
                        ColorUtil().primaryRed,
                        // Color(0xFFFFBBCF),
                        // Color(0xFFA665D1),
                        // Color(0xFFFFBBCF),
                      ]),
                    ),
                  ),
                  clipper: BottomWaveClipper(),
                ),

                ///
                /// Get triangle widget
                ///
                _triangle(
                  20.0,
                  10.0,
                ),
                _triangle(
                  110.0,
                  80.0,
                ),
                _triangle(
                  60.0,
                  190.0,
                ),
                _triangle(
                  40.0,
                  300.0,
                ),
                _triangle(
                  130.0,
                  330.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0, left: 20.0),
                  child: Text(
                    "Settings",
                    style:
                        TextStyle(fontSize: 27.0, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                )
              ],
            ),

            ///
            /// Create list for category
            ///
            // category(
            //   txt: "Notification",
            //   padding: 35.0,
            //   image: "assets/images/notification.png",
            //   tap: () {},
            // ),
            // _line(),
            // category(
            //   txt: "Payments",
            //   padding: 35.0,
            //   image: "assets/images/creditAcount.png",
            //   tap: () {},
            // ),
            // _line(),
            // category(
            //   txt: "Message",
            //   padding: 26.0,
            //   image: "assets/images/chat.png",
            //   tap: () {},
            // ),
            // _line(),
            // category(
            //   txt: "Setting Acount",
            //   padding: 30.0,
            //   image: "assets/images/setting.png",
            //   tap: () {},
            // ),
            // _line(),
            category(
              txt: "Call Center",
              padding: 30.0,
              image: "assets/images/callcenter.png",
              tap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CallCenterScreen(),
                  ),
                );
              },
            ),
            _line(),
            category(
              padding: 38.0,
              txt: "Terms & Conditions",
              image: "assets/images/aboutapp.png",
              tap: () {
                if (pathPDF.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFScreen(),
                    ),
                  );
                }
              },
            ),
            _line(),
            category(
              padding: 38.0,
              txt: "Log Out",
              image: "assets/images/logout.png",
              tap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Log Out"),
                        content: Text("Are you sure you want to log out?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Cancel", style: TextStyle(color: Colors.green)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text("Log Out", style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              LoginController().logOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) =>
                                        const EnterNumber(
                                      flag: "login",
                                    ),
                                    transitionsBuilder:
                                        (context, animation, secondaryAnimation, child) {
                                      return child;
                                    },
                                  ),
                                  (route) => false);
                            },
                          ),
                        ],
                      );
                    });
                // SystemNavigator.pop();
              },
            ),
            _line(),
            // Padding(padding: EdgeInsets.only(bottom: 20.0)),
          ],
        ),
      ),
    );
  }

  Widget _line() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 85.0, right: 30.0),
      child: Divider(
        color: Colors.black12,
        height: 2.0,
      ),
    );
  }

  ///
  /// Create triangle
  ///
  Widget _triangle(double top, left) {
    return Padding(
      padding: EdgeInsets.only(top: top, left: left),
      child: ClipPath(
        child: Container(
          height: 40.0,
          width: 40.0,
          color: Colors.white12.withOpacity(0.09),
        ),
        clipper: TriangleClipper(),
      ),
    );
  }
}

///
/// Create wave appbar
///
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

///
/// Create triangle clipper
///
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

/// Custom Font
var _txt = TextStyle(
  color: Colors.black,
);

/// Get _txt and custom value of Variable for Category Text
var _txtCategory =
    _txt.copyWith(fontSize: 14.5, color: Colors.black54, fontWeight: FontWeight.bold);

/// Component category class to set list
class category extends StatelessWidget {
  @override
  String txt, image;
  GestureTapCallback tap;
  double padding;

  category({required this.txt, required this.image, required this.tap, required this.padding});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 30.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: padding),
                  child: Image.asset(
                    image,
                    height: 25.0,
                    color: ColorUtil().primaryRed,
                    // color: Color(0xFFA665D1),
                  ),
                ),
                Text(
                  txt,
                  style: _txtCategory,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
