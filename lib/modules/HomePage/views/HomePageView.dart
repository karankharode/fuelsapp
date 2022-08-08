// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fuelsapp/modules/Auth/Login/controller/LoginController.dart';
import 'package:fuelsapp/modules/Auth/Login/model/LoginResponseModel.dart';
import 'package:fuelsapp/modules/CardPage/views/CardPageView.dart';
import 'package:fuelsapp/modules/History/views/HistoryPage.dart';
import 'package:fuelsapp/modules/HomePage/controller/QRController.dart';
import 'package:fuelsapp/modules/HomePage/model/QrPaymentStatusResponse.dart';
import 'package:fuelsapp/modules/ProfilePage/views/ProfilePageView.dart';
import 'package:fuelsapp/modules/Settings/views/SettingsView.dart';
import 'package:fuelsapp/utils/AnimationUtil.dart';
import 'package:fuelsapp/utils/ColorUtil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../utils/common.dart';
import '../model/QrResponse.dart';

class HomePageView extends StatefulWidget {
  // final String accessToken;
  // final String civilId;
  // final String phone;
  const HomePageView({
    Key? key,
    // required this.accessToken,
    // required this.civilId,
    // required this.phone,
  }) : super(key: key);

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> with TickerProviderStateMixin {
  int index = 0;
  late Size size;
  List bodyList = [
    const CardPage(),
    ProfilePageView(),
    const HistoryPage(),
    SettingsView(),
  ];

  late Future<QRResponse> myFuture;
  late LoginController loginController;
  late LoginResponse loginResponse;

  @override
  void initState() {
    super.initState();
    startPageLoadAnimations(
      animationsMap.values.where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
    setupTriggerAnimations(
      animationsMap.values.where((anim) => anim.trigger == AnimationTrigger.onActionTrigger),
      this,
    );
    getSavedUserDetails();
    getWalletsList();
  }

  getSavedUserDetails() async {
    loginResponse = await LoginController().getSavedUserDetails();
    setState(() {});
  }

  getWalletsList() async {
    walletResponseModel = await QRController().getWalletId();
    setState(() {});
  }

  Future<QRResponse> generateQr() async {
    QRResponse result = await QRController()
        .generateQr(walletId: walletResponseModel.subsidyAccountBalance.account);
    return result;
  }

  showQRDialog() {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Container();
        },
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.4),
        barrierLabel: '',
        transitionDuration: Duration(milliseconds: 500),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, -(curvedValue * 200), 0.0),
            child: Opacity(
                // opacity: 1,
                opacity: a1.value,
                child: AlertDialog(
                  scrollable: true,
                  contentPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: SingleChildScrollView(
                      child: Container(
                    height: size.height / 1.2,
                    width: size.width / 1.2,
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/Scan now BG@3x.png",
                          fit: BoxFit.fill,
                          height: size.height / 1.3,
                          width: size.width / 1.2,
                        ),
                        SizedBox(
                          height: size.height / 1.3,
                          width: size.width / 1.2,
                          child: FutureBuilder<QRResponse>(
                              future: myFuture,
                              builder: (context, snapshot) {
                                return StreamBuilder<QrPaymentStatusResponse>(
                                    stream: Stream.periodic(Duration(seconds: 1))
                                        .asyncMap((i) => QRController().getQRPaymentStatus(
                                              // "8d14e453-7a2e-4657-b679-638184ffa287"
                                              snapshot.data?.trxRefId ?? "",
                                            )),
                                    builder: (context, snapshotForStream) {
                                      bool balanceSufficient = true;
                                      try {
                                        balanceSufficient = double.parse(!(snapshotForStream.data ==
                                                        null ||
                                                    snapshotForStream.data?.balanceLiter == "null")
                                                ? snapshotForStream.data?.balanceLiter ?? "0.0"
                                                : walletResponseModel
                                                    .subsidyAccountBalance.availableLiter) <=
                                            0.0;
                                      } catch (e) {
                                        balanceSufficient = false;
                                      }
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 219,
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Image.asset("assets/images/scan now@3x.png",
                                                        color: balanceSufficient
                                                            ? Colors.red
                                                            : Colors.green),
                                                    Container(
                                                      height: 77,
                                                      child: const Center(
                                                        child: Text(
                                                          "Scan Now",
                                                          style: TextStyle(
                                                            color: Color(0xFFffffff),
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 25.0, vertical: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text(
                                                        "Remaining Time",
                                                        style: TextStyle(
                                                          color: const Color(0xFF888888),
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      const remainingTimer(),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 25.0,
                                                  ),
                                                  child: Container(
                                                    height: 1,
                                                    decoration: BoxDecoration(
                                                        gradient: LinearGradient(colors: [
                                                      const Color(0xffFFFFFF),
                                                      const Color(0xffADB5BD),
                                                      const Color(0xffADB5BD).withOpacity(0.0)
                                                    ])),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 30.0,
                                                        vertical: 30.0,
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          // Text(DateTime.now().toString()),

                                                          getQRWidgetByStatus(
                                                            snapshot,
                                                            (snapshotForStream.data?.status
                                                                    .toString() ??
                                                                "PROCESSING"),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 1,
                                            margin: const EdgeInsets.symmetric(horizontal: 22),
                                            child: const MySeparator(),
                                          ),
                                          Expanded(
                                            flex: 100,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                const Spacer(),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                      text: !(snapshotForStream.data == null ||
                                                              snapshotForStream
                                                                      .data?.balanceLiter ==
                                                                  "null")
                                                          ? snapshotForStream.data?.balanceLiter ??
                                                              ""
                                                          : walletResponseModel
                                                              .subsidyAccountBalance.availableLiter
                                                              .toString(),
                                                      style: const TextStyle(
                                                        color: Color(0xff000000),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 32,
                                                      )),
                                                  const TextSpan(
                                                      text: " Ltr",
                                                      style: TextStyle(
                                                        color: Color(0xff888888),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 42,
                                                      )),
                                                ])),
                                                Container(
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  padding: const EdgeInsets.fromLTRB(13, 7, 13, 7),
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xEE3124,
                                                      ).withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(40)),
                                                  child: const Text(
                                                    "Your Balance",
                                                    style: const TextStyle(
                                                      color: Color(0xffEE3124),
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                InkWell(
                                                  onTap: () => Navigator.pop(context),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(7.0),
                                                    child: Image.asset(
                                                      "assets/images/Close@3x.png",
                                                      height: 63,
                                                      width: 63,
                                                    ).animated(
                                                        [animationsMap['qrButtonClickAnimation']!]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              }),
                        )
                      ],
                    ),
                  )),
                )),
          );
        });
  }

  Widget getQRWidgetByStatus(
    AsyncSnapshot<QRResponse> snapshot,
    String qrPaymentStatus,
  ) {
    switch (snapshot.connectionState) {
      case ConnectionState.done:
        switch (qrPaymentStatus) {
          case "SUCCESS":
            getWalletsList();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Lottie.asset('assets/animations/success.json',
                  height: (size.height / 1.3) * (219 / 319) / 2.3,
                  // width: 50,
                  fit: BoxFit.contain),
            );

          case "PROCESSING":
            try {
              return snapshot.data!.success
                  ? Image.memory(
                      snapshot.data!.image,
                      fit: BoxFit.fill,
                    )
                  : Icon(
                      Icons.error,
                      color: ColorUtil().primaryRed,
                    );
            } catch (e) {
              return Icon(
                Icons.error,
                color: Colors.green,
                // color: ColorUtil().primaryRed,
              );
            }

          default:
            try {
              return Image.memory(
                snapshot.data!.image,
                fit: BoxFit.fill,
              );
            } catch (e) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.yellow,
                    // color: ColorUtil().primaryRed,
                  ),
                ],
              );
            }
        }
      case ConnectionState.waiting:
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 25, width: 25, child: CircularProgressIndicator()),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    loginController = Provider.of<LoginController>(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: 120,
            width: size.width,
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: const Color(0xffe8e8e8).withOpacity(0.3),
            ),
            child: Image.asset(
              "assets/images/Bottom bar@3x.png",
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                NavBarItem(
                    image: "assets/images/Home@3x.png",
                    selected: index == 0,
                    onTap: () {
                      if (index != 0) {
                        setState(() {
                          index = 0;
                        });
                      }
                    }),
                const Spacer(flex: 2),
                NavBarItem(
                    image: "assets/images/user.png",
                    selected: index == 1,
                    onTap: () {
                      if (index != 1) {
                        setState(() {
                          index = 1;
                        });
                      }
                    }),
                GestureDetector(
                  onTap: () async {
                    // final animation = animationsMap['qrButtonClickAnimation'];
                    myFuture = generateQr();
                    // setState(() {});
                    showQRDialog();
                    // await (animation!.curvedAnimation.parent as AnimationController)
                    //     .forward(from: 0.0);
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Image.asset("assets/images/Scan@3x.png")),
                ).animated([animationsMap['floatingActionButtonOnPageLoadAnimation']!]),
                NavBarItem(
                    image: "assets/images/History@3x.png",
                    selected: index == 2,
                    onTap: () {
                      if (index != 2) {
                        setState(() {
                          index = 2;
                        });
                      }
                    }),
                const Spacer(flex: 2),
                NavBarItem(
                    image: "assets/images/Settings@3x.png",
                    selected: index == 3,
                    onTap: () {
                      if (index != 3) {
                        //debugPrint("Pressed");
                        setState(() {
                          index = 3;
                        });
                      }
                    }),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ],
      ),
      body:
          SafeArea(child: bodyList[index]).animated([animationsMap['columnOnPageLoadAnimation']!]),
    );
  }
}

class remainingTimer extends StatefulWidget {
  const remainingTimer({
    Key? key,
  }) : super(key: key);

  @override
  State<remainingTimer> createState() => _remainingTimerState();
}

class _remainingTimerState extends State<remainingTimer> {
  bool timeUpFlag = false;
  int timeCounter = 0;
  String _timerText = '0:00';
  late Timer timer;

  _timerUpdate() {
    timer = Timer(const Duration(seconds: 1), () async {
      setState(() {
        timeCounter--;
        _timerText = "${(timeCounter ~/ 60).toString()}:${(timeCounter % 60).toString()} ";
      });
      if (timeCounter != 0 && !timeUpFlag) {
        _timerUpdate();
      } else {
        timeUpFlag = true;
        Navigator.pop(context);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    timeCounter = 300;
    _timerUpdate();
  }

  @override
  void dispose() {
    // timeUpFlag = true;
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timerText,
      style: TextStyle(
        color: Color(0xFF000000),
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  const NavBarItem({
    Key? key,
    required this.image,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  final String image;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 28.0, left: 10, right: 10),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.asset(
                image,
                height: 25,
                width: 25,
                color: selected ? Color(0xFFFA961E) : Color(0xFF8C7864),
              ),
            ),
            selected
                ? Positioned(
                    bottom: 1,
                    left: 10,
                    child: Container(
                      height: 5,
                      width: 5,
                      decoration:
                          const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFA961E)),
                    ),
                  )
                : const SizedBox(
                    height: 5,
                    width: 5,
                  )
          ],
        ),
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (2 * 3)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.0),
              child: SizedBox(
                width: 4,
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: const Color(0xffCED4DA)),
                ),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
