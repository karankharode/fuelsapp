import 'package:flutter/material.dart';
import 'package:fuelsapp/modules/History/controllers/RecentTransactionsController.dart';
import 'package:fuelsapp/modules/History/model/RecentTransactionListResponse.dart';
import 'package:fuelsapp/utils/ColorUtil.dart';
import 'package:fuelsapp/utils/ThemeUtil.dart';
import 'package:jiffy/jiffy.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late RecentTransactionListResponse recentTransactionListResponse;
  bool recentTransactionListResponseFetched = false;
  late Size size;

  @override
  void initState() {
    super.initState();
    getrecentTransactionListResponse();
  }

  getrecentTransactionListResponse() async {
    //debugPrint("refresh");
    recentTransactionListResponse = await RecentTransactionController().getRecentTransactionList();
    setState(() {
      recentTransactionListResponseFetched = true;
    });
  }

  showHistoryDialo(RecentTransactionModel recentTransactionModel) {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Container();
        },
        barrierDismissible: true,
        barrierColor: const Color(0xff3C0400).withOpacity(0.5),
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 400),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, (curvedValue * 200), 0.0),
            child: Opacity(
              // opacity: 1,
              opacity: a1.value,
              child: AlertDialog(
                scrollable: true,
                contentPadding: const EdgeInsets.only(top: 40),
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: SingleChildScrollView(
                    child: Container(
                  height: size.height / (812 / 505),
                  width: size.width / (375 / 315),
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/images/historyDialog.png",
                        fit: BoxFit.fill,
                        height: size.height / (812 / 505),
                        width: size.width / (375 / 315),
                      ),
                      Container(
                        height: size.height / (812 / 505),
                        width: size.width / (375 / 315),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 314,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // tick
                                  Image.asset(
                                    "assets/images/tick-mark@3x.png",
                                    height: 74,
                                    width: 74,
                                  ),

                                  Column(
                                    children: [
                                      Text("${recentTransactionModel.approvedLiter} Ltr",
                                          style: ThemeUtil.title1.copyWith(fontSize: 34)),
                                      RichText(
                                          text: TextSpan(children: [
                                        const TextSpan(
                                            text: "Fuel Filled",
                                            style: TextStyle(
                                              color: Color(0xff555555),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            )),
                                        TextSpan(
                                            text: " (${recentTransactionModel.totalAmount} OMR)",
                                            style: const TextStyle(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            )),
                                      ])),
                                    ],
                                  ),

                                  // small divider
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 45.0,
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

                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/station@3x.png",
                                            height: 34,
                                            width: 34,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            recentTransactionModel.stationName,
                                            style: ThemeUtil.title1.copyWith(fontSize: 16),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        Jiffy(
                                                recentTransactionModel.transactionDate
                                                    .replaceAll("T", " "),
                                                "yyyy-MM-dd hh:mm:ss")
                                            .yMMMEdjm,
                                        style: ThemeUtil.title1.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff555555)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                  const Color(0xffE9ECEF).withOpacity(0.0),
                                  const Color(0xffE9ECEF),
                                  const Color(0xffE9ECEF),
                                  const Color(0xffE9ECEF),
                                  const Color(0xffE9ECEF),
                                  const Color(0xffE9ECEF).withOpacity(0.0),
                                ])),
                              ),
                            ),
                            Expanded(
                              flex: 190,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // balance figures
                                  Column(
                                    children: [
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: recentTransactionModel.balanceLiter,
                                            style: const TextStyle(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 42,
                                            )),
                                        const TextSpan(
                                            text: " Ltr",
                                            style: TextStyle(
                                              color: Color(0xff888888),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 42,
                                            )),
                                      ])),
                                      const Text(
                                        "Balance",
                                        style: TextStyle(
                                          color: Color(0xff555555),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // button
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 142,
                                      decoration: BoxDecoration(
                                        color: ColorUtil().primaryRed,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      child: const Center(
                                        child: Text(
                                          "Okay",
                                          style: TextStyle(color: Colors.white, fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: RefreshIndicator(
        onRefresh: () => getrecentTransactionListResponse(),
        child: SizedBox(
          height: size.height,
          child: Column(
            children: [
              const HistoryAppBarWidget(),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  decoration: BoxDecoration(
                      color: const Color(0xffE8E8E8).withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(35), topRight: Radius.circular(35))),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          "Last Transaction",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        !recentTransactionListResponseFetched
                            ? Container(
                                width: double.infinity,
                                height: size.height / 1.8,
                                child: Center(
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    child: const CircularProgressIndicator(),
                                  ),
                                ))
                            : ListView.builder(
                                itemCount:
                                    recentTransactionListResponse.recentTransactionList.length,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(0, 25, 0, 55),
                                itemBuilder: (BuildContext context, int index) {
                                  RecentTransactionModel recentTransactionModel =
                                      recentTransactionListResponse.recentTransactionList[index];
                                  return InkWell(
                                    onTap: () => showHistoryDialo(recentTransactionModel),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      decoration: BoxDecoration(
                                          color: const Color(0xffFFFFFF),
                                          borderRadius: BorderRadius.circular(16)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 102,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  RichText(
                                                      text: TextSpan(children: [
                                                    TextSpan(
                                                        text: Jiffy(
                                                                recentTransactionModel
                                                                    .transactionDate
                                                                    .replaceAll("T", " "),
                                                                "yyyy-MM-dd hh:mm:ss")
                                                            .date
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 28,
                                                        )),
                                                    TextSpan(
                                                        text:
                                                            '  ${Jiffy(recentTransactionModel.transactionDate.replaceAll("T", " "), "yyyy-MM-dd hh:mm:ss").MMM}',
                                                        style: const TextStyle(
                                                          color: const Color(0xff888888),
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 15,
                                                        )),
                                                  ])),
                                                  Container(
                                                    height: 45,
                                                    width: 1,
                                                    color: const Color(0xffE8E8E8),
                                                  )
                                                ],
                                              )),
                                          Expanded(
                                              flex: 232,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        recentTransactionModel.approvedLiter,
                                                        style: const TextStyle(
                                                          // color: Color(0xFFEE3124),
                                                          color: const Color(0xFF40C057),
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      RichText(
                                                          text: TextSpan(children: [
                                                        const TextSpan(
                                                            text: "Remaining Amount: ",
                                                            style:  TextStyle(
                                                              color: const Color(0xff888888),
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 14,
                                                            )),
                                                        TextSpan(
                                                            text:
                                                                "${recentTransactionModel.balanceLiter} Ltr",
                                                            style: const TextStyle(
                                                              color:  Color(0xff000000),
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 14,
                                                            )),
                                                      ])),
                                                    ],
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                        SizedBox(
                          height: 200,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryAppBarWidget extends StatelessWidget {
  const HistoryAppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16 + 10, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: "Today", style: ThemeUtil.subtitle1Red),
              ])),
              Text(
                Jiffy().yMMMd,
                style: ThemeUtil.title2,
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xffEE3124).withOpacity(0.0),
                          const Color(0xffEE3124).withOpacity(0.4),
                        ])),
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  "assets/images/menu.png",
                  height: 25,
                  width: 25,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
