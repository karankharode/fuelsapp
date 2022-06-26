class RecentTransactionListResponse {
  final List<RecentTransactionModel> recentTransactionList;
  final bool success;

  RecentTransactionListResponse({
    required this.recentTransactionList,
    required this.success,
  });

  factory RecentTransactionListResponse.fromResponse(List response) {
    List<RecentTransactionModel> recentTransactionList = [];
    for (var i = 0; i < response.length; i++) {
      RecentTransactionModel recentTransactionModel =
          RecentTransactionModel.fromResponse(response[i]);
      // for (var j = 0; j < 10; j++) {

      recentTransactionList.add(recentTransactionModel);
      // }
    }

    return RecentTransactionListResponse(
        recentTransactionList: recentTransactionList, success: true);
  }
}

class RecentTransactionModel {
  final String createdAt; // "2022-02-12T16:23:02.818127",
  final String createdBy; // "posadmin",
  final String updatedAt; // "2022-02-12T16:23:06.071342",
  final String updatedBy; // "posadmin",
  final String id; // 211,
  final String transactionType; // "AUTHORIZE",
  final String orderType; // "DISCOUNT",
  final String paymentMethod; // "CARD",
  final String requestLiter; // 0.200,
  final String approvedLiter; // 0.200,
  final String balanceLiter; // 66.503,
  final String qrCode; // null,
  final String card; // "8010100001020010",
  final String account; // "5097721254286",
  final String customer; // 1,
  final String transactionRef; // "GTJH4PJ7JRZBRLKJXEPUNQURJSE=",
  final String approvalCode; // "012156",
  final String status; // "COMPLETED",
  final String invoiceNo; // "000001",
  final String shiftNo; // "001",
  final String attendantId; // "5800",
  final String batchNo; // "000009",
  final String posId; // "999001001",
  final String stationId; // "999001",
  final String stationName; // "999001",
  final String pumpId; // null,
  final String vehicleNo; // "549",
  final String feeAmount; // null,
  final String baseAmount; // 0.045,
  final String discountAmount; // 0.009,
  final String totalAmount; // 0.036,
  final String fuelProduct; // "MOGAS-91",
  final String subsidyProduct; // "001",
  final String traceNo; // "000001",
  final String civilId; // "656729644",
  final String customerName; // "Pugzhendhi Thanikasalam",
  final String transactionDate; // "2022-02-12T16:23:13.99",
  final String authorizeDate; // "2022-02-12T16:23:02.813368",
  final String completeDate; // "2022-02-12T16:23:04.608781",
  final String voidDate; // null,
  final String settlementDate; // null,
  final String odometer; // null

  factory RecentTransactionModel.fromResponse(Map response) {
    return RecentTransactionModel(
      createdAt: response["createdAt"].toString(),
      createdBy: response["createdBy"].toString(),
      updatedAt: response["updatedAt"].toString(),
      updatedBy: response["updatedBy"].toString(),
      id: response["id"].toString(),
      transactionType: response["transactionType"].toString(),
      orderType: response["orderType"].toString(),
      paymentMethod: response["paymentMethod"].toString(),
      requestLiter: response["requestLiter"].toString(),
      approvedLiter: response["approvedLiter"].toString(),
      balanceLiter: response["balanceLiter"].toString(),
      qrCode: response["qrCode"].toString(),
      card: response["card"].toString(),
      account: response["account"].toString(),
      customer: response["customer"].toString(),
      transactionRef: response["transactionRef"].toString(),
      approvalCode: response["approvalCode"].toString(),
      status: response["status"].toString(),
      invoiceNo: response["invoiceNo"].toString(),
      shiftNo: response["shiftNo"].toString(),
      attendantId: response["attendantId"].toString(),
      batchNo: response["batchNo"].toString(),
      posId: response["posId"].toString(),
      stationId: response["stationId"].toString(),
      stationName: response["stationName"].toString(),
      pumpId: response["pumpId"].toString(),
      vehicleNo: response["vehicleNo"].toString(),
      feeAmount: response["feeAmount"].toString(),
      baseAmount: response["baseAmount"].toString(),
      discountAmount: response["discountAmount"].toString(),
      totalAmount: response["totalAmount"].toString(),
      fuelProduct: response["fuelProduct"].toString(),
      subsidyProduct: response["subsidyProduct"].toString(),
      traceNo: response["traceNo"].toString(),
      civilId: response["civilId"].toString(),
      customerName: response["customerName"].toString(),
      transactionDate: response["transactionDate"].toString(),
      authorizeDate: response["authorizeDate"].toString(),
      completeDate: response["completeDate"].toString(),
      voidDate: response["voidDate"].toString(),
      settlementDate: response['settlementDate'].toString(),
      odometer: response["odometer"].toString(),
    );
  }

  RecentTransactionModel(
      {required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      required this.id,
      required this.transactionType,
      required this.orderType,
      required this.paymentMethod,
      required this.requestLiter,
      required this.approvedLiter,
      required this.balanceLiter,
      required this.qrCode,
      required this.card,
      required this.account,
      required this.customer,
      required this.transactionRef,
      required this.approvalCode,
      required this.status,
      required this.invoiceNo,
      required this.shiftNo,
      required this.attendantId,
      required this.batchNo,
      required this.posId,
      required this.stationId,
      required this.stationName,
      required this.pumpId,
      required this.vehicleNo,
      required this.feeAmount,
      required this.baseAmount,
      required this.discountAmount,
      required this.totalAmount,
      required this.fuelProduct,
      required this.subsidyProduct,
      required this.traceNo,
      required this.civilId,
      required this.customerName,
      required this.transactionDate,
      required this.authorizeDate,
      required this.completeDate,
      required this.voidDate,
      required this.settlementDate,
      required this.odometer});
}
