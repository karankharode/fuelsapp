import 'package:flutter/material.dart';
import 'package:fuelsapp/modules/CardPage/views/CardPageView.dart';
import 'package:fuelsapp/utils/ColorUtil.dart';

import '../../Auth/Login/controller/LoginController.dart';
import '../../Auth/Login/model/LoginResponseModel.dart';
import '../../CardPage/controllers/CardController.dart';
import '../../CardPage/models/CardListResponse.dart';

late LoginResponse loginResponse;

late CardListResponse cardListResponse;

bool cardFetched = false;
bool loginResponseFetched = false;

class ProfilePageView extends StatefulWidget {
  ProfilePageView();

  _ProfilePageViewState createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  @override
  void initState() {
    super.initState();
    getSavedUserDetails();

    getCardDetails();
  }

  getSavedUserDetails() async {
    loginResponse = await LoginController().getSavedUserDetails();
    setState(() {
      loginResponseFetched = true;
    });
  }

  getCardDetails() async {
    cardListResponse = await CardController().getCardList();
    // //debugPrint(cardListResponse);
    setState(() {
      cardFetched = true;
    });
  }

  @override
  static final _txtCustomHead = TextStyle(
    color: Colors.black54,
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
  );

  static var _txtCustomSub = const TextStyle(
    color: Colors.black38,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
  );

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
                    height: 200.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        ColorUtil().primaryRed.withOpacity(0.8),
                        ColorUtil().primaryRed,
                        // Color(0xFFFFBBCF),
                        // Color(0xFFA665D1),
                        // Color(0xFFFFBBCF),
                      ]),
                    ),
                  ),
                  clipper: BottomWaveClipperProfile(),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 40.0, left: 20.0),
                      child: Column(
                        children: [
                          Text(
                            loginResponseFetched ? loginResponse.firstName : "User Profile",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          CircleAvatar(
                            radius: 40.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: ColorUtil().primaryRed, size: 60),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),

            loginResponseFetched
                ? Column(
                    children: [
                      category(
                        txt: loginResponseFetched ? loginResponse.firstName : "User ",
                        padding: 30.0,
                        image: Icons.person,
                        tap: () {},
                      ),
                      _line(),
                      category(
                        txt: loginResponseFetched ? loginResponse.citizenId : "Civil ID ",
                        padding: 30.0,
                        image: Icons.confirmation_number_outlined,
                        tap: () {},
                      ),
                      _line(),
                      category(
                        txt: loginResponseFetched ? loginResponse.vehicleNo : "Vehicle Number ",
                        padding: 30.0,
                        image: Icons.car_rental,
                        tap: () {},
                      ),
                      _line(),
                      category(
                        txt: loginResponseFetched ? loginResponse.phone : "Phone Number ",
                        padding: 30.0,
                        image: Icons.phone,
                        tap: () {},
                      ),
                      _line(),
                      category(
                        txt: cardFetched ? cardListResponse.cardList[0].cardNo : "Card Number ",
                        padding: 30.0,
                        image: Icons.credit_card,
                        tap: () {},
                      ),
                      _line(),
                    ],
                  )
                : CircularProgressIndicator()

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

            // Padding(padding: EdgeInsets.only(bottom: 20.0)),
          ],
        ),
      ),
    );
  }

  Widget _line() {
    return const Padding(
      padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 5),
      child: const Divider(
        color: Colors.black,
        height: 2.0,
      ),
    );
  }
}

/// Custom Font
var _txt = const TextStyle(
  color: Colors.black,
);

/// Get _txt and custom value of Variable for Category Text
var _txtCategory =
    _txt.copyWith(fontSize: 14.5, color: Colors.black54, fontWeight: FontWeight.bold);

/// Component category class to set list
class category extends StatelessWidget {
  @override
  String txt;
  IconData image;
  GestureTapCallback tap;
  double padding;

  category({required this.txt, required this.image, required this.tap, required this.padding});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 30.0, bottom: 20),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: padding),
                  child: Icon(
                    image,
                    size: 25.0,
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

class BottomWaveClipperProfile extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 100);

    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 100);

    // path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
