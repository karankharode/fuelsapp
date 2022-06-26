import 'package:flutter/material.dart';
import 'package:fuelsapp/modules/Auth/Login/model/LoginResponseModel.dart';
import 'package:fuelsapp/modules/CardPage/controllers/CardController.dart';
import 'package:fuelsapp/modules/CardPage/models/CardListResponse.dart';
import 'package:fuelsapp/utils/ColorUtil.dart';
import 'package:fuelsapp/utils/ThemeUtil.dart';

import '../../../utils/common.dart';
import '../../Auth/Login/controller/LoginController.dart';
import '../../HomePage/controller/QRController.dart';

late CardListResponse cardListResponse;
late LoginResponse loginResponse;

bool cardFetched = false;
bool logimRespnseFetched = false;

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> with TickerProviderStateMixin {
  late Size size;

  @override
  void initState() {
    // TODO: implement initState
    getSavedUserDetails();
    getCardDetails();
    getWalletsList();
    super.initState();
  }

  getSavedUserDetails() async {
    loginResponse = await LoginController().getSavedUserDetails();
    setState(() {
      logimRespnseFetched = true;
    });
  }

  getCardDetails() async {
    cardListResponse = await CardController().getCardList();
    // //debugPrint(cardListResponse);
    setState(() {
      cardFetched = true;
    });
  }

  getWalletsList() async {
    walletResponseModel = await QRController().getWalletId();
    setState(() {
      walletRespnseFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () => getWalletsList(),
      child: Container(
        height: size.height,
        color: Color(0xffE8E8E8).withOpacity(0.3),
        child: ListView(physics: BouncingScrollPhysics(), children: [
          // app bar

          AppBarWidget(
            name: logimRespnseFetched ? loginResponse.firstName : "User",
          ),

          // card ui
          cardFetched && logimRespnseFetched
              ? CardWidget(
                  size: size,
                  civilId: loginResponse.citizenId,
                  cardModel: cardListResponse.cardList[0],
                  name: logimRespnseFetched
                      ? loginResponse.firstName.split(" ").first.toString()
                      : "User",
                  balance: walletResponseModel.subsidyAccountBalance.availableLiter,
                  vehicleNo: loginResponse.vehicleNo + " " + loginResponse.registrationRegion,
                )
              : Container(),

          Container(
            color: Colors.white,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
              decoration: BoxDecoration(
                  color: Color(0xffE8E8E8).withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35), topRight: Radius.circular(35))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "More",
                    style: ThemeUtil.moreStyle,
                  ),
                  // Spacer(
                  //   flex: 1,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      statsWidget(
                          remainingBalance: true,
                          stat: walletRespnseFetched
                              ? walletResponseModel.subsidyAccountBalance.availableLiter
                              : "0"),
                      statsWidget(
                          remainingBalance: false,
                          stat: loginResponse.vehicleNo + " " + loginResponse.registrationRegion),
                    ],
                  ),
                  // Spacer(
                  //   flex: 2,
                  // )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
    required this.size,
    required this.cardModel,
    required this.name,
    required this.civilId,
    required this.balance,
    required this.vehicleNo,
  }) : super(key: key);

  final Size size;
  final CardModel cardModel;
  final String name;
  final String civilId;
  final String balance;
  final String vehicleNo;

  formatCardNumber(String cardNumber) {
    List numberList = cardNumber.split("");
    numberList.insert(4, " ");
    numberList.insert(9, " ");
    numberList.insert(14, " ");
    return numberList.join("");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Material(
              elevation: 15,
              shadowColor: ColorUtil().primaryRed.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: (size.width - 40) / 1.55,
                width: size.width - 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: AssetImage("assets/images/Virtual_Card@3x.jpg"),
                        fit: BoxFit.fitHeight)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 45, 12, 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                balance,
                                style: ThemeUtil.title1White,
                              ),
                              Text(
                                "Balance",
                                style: ThemeUtil.subtitle2Grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          formatCardNumber(cardModel.cardNo),
                          style: ThemeUtil.cardNumber,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: ThemeUtil.bodyText1,
                                ),
                                Text(
                                  civilId,
                                  style: ThemeUtil.cardNumber.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 218, 95, 89),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                vehicleNo.trim(),
                                style: ThemeUtil.bodyText1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 15,
          //   right: size.width / 2 - 12.5,
          //   child: Image.asset(
          //     "assets/images/Slider@3x.png",
          //     height: 25,
          //     width: 25,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class statsWidget extends StatelessWidget {
  const statsWidget({Key? key, required this.remainingBalance, required this.stat})
      : super(key: key);
  final bool remainingBalance;
  final String stat;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 8, 10),
        margin: const EdgeInsets.fromLTRB(0, 10, 20, 10),
        decoration:
            BoxDecoration(color: Color(0xffffffff), borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15, 12, 15, 10),
              padding: EdgeInsets.fromLTRB(10, 12, 10, 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xffffffff), width: 0.5),
                boxShadow: [
                  BoxShadow(
                      color: remainingBalance
                          ? Color(0xffF7961E).withOpacity(0.7)
                          : Color(0xffEE3124).withOpacity(0.7),
                      blurRadius: 15,
                      offset: Offset(2, 5))
                ],
                color: remainingBalance ? Color(0xffF7961E) : Color(0xffEE3124),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  remainingBalance ? "assets/images/oil_icon.png" : "assets/images/car_icon.png",
                  color: Colors.white,
                  height: 24,
                  width: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        stat.trim(),
                        style: ThemeUtil.title1Balance,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    remainingBalance ? "Remaining\nBalance" : "Vehicle\nNumber",
                    style: ThemeUtil.subtitle1Balance,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    remainingBalance ? "الكمية المتبقية" : "رقم المركبة",
                    style: ThemeUtil.subtitle1Balance.copyWith(
                        color: remainingBalance ? ColorUtil().primaryRed : Color(0xffF7961E)),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  "assets/images/pattern1.png",
                  height: 20,
                  width: 15,
                  color: remainingBalance ? Color(0xffF7961E) : Color(0xffEE3124),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    Key? key,
    required this.name,
  }) : super(key: key);
  final String name;

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16 + 4, 16, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "Hey, ", style: ThemeUtil.subtitle1),
                  TextSpan(text: name, style: ThemeUtil.subtitle1Red),
                ])),
                Text(
                  "Good ${greeting()}",
                  style: ThemeUtil.title2,
                ),
              ],
            ),
            Row(
              children: [
                // InkWell(
                //   onTap: () {
                //     // Navigator.push(
                //     //     context,
                //     //     PageRouteBuilder(
                //     //       pageBuilder: (context, animation, secondaryAnimation) =>
                //     //           const MapPageView(),
                //     //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
                //     //         return child;
                //     //       },
                //     //     ));
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         gradient: LinearGradient(
                //             begin: Alignment.topLeft,
                //             end: Alignment.bottomRight,
                //             colors: [
                //               const Color(0xff000000).withOpacity(0.05),
                //               const Color(0xff000000).withOpacity(0.05),
                //             ])),
                //     padding: const EdgeInsets.all(12),
                //     child: Image.asset(
                //       "assets/images/Location3@3x.png",
                //       color: Colors.black,
                //       height: 25,
                //       width: 25,
                //     ),
                //   ),
                // ),

                const SizedBox(
                  width: 15,
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       gradient: LinearGradient(
                //           begin: Alignment.topLeft,
                //           end: Alignment.bottomRight,
                //           colors: [
                //             const Color(0xffEE3124).withOpacity(0.0),
                //             const Color(0xffEE3124).withOpacity(0.4),
                //           ])),
                //   padding: const EdgeInsets.all(12),
                //   child: Image.asset(
                //     "assets/images/menu.png",
                //     height: 25,
                //     width: 25,
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
