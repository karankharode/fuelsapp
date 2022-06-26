class QrPaymentStatusResponse {
  final String authorizedLiter; // ": null,
  final String balanceLiter; // ": null,
  final String orgBalanceLiter; // ": null,
  final String status; // ": "PROCESSING",
  final String approvalCode; // ": null,
  final String transactionRef; // ": null,
  final String invoiceId; // ": null,
  final String qrRef; // ": null,
  final String customerId; // ": null,
  final String customerName; // ": null

  factory QrPaymentStatusResponse.fromResponse(Map response) {
    return QrPaymentStatusResponse(
      authorizedLiter: response["authorizedLiter"].toString(),
      balanceLiter: response["balanceLiter"].toString(),
      orgBalanceLiter: response["orgBalanceLiter"].toString(),
      status: response["status"].toString(),
      approvalCode: response["approvalCode"].toString(),
      transactionRef: response["transactionRef"].toString(),
      invoiceId: response["invoiceId"].toString(),
      qrRef: response["qrRef"].toString(),
      customerId: response["customerId"].toString(),
      customerName: response["customerName"].toString(),
    );
  }
  QrPaymentStatusResponse({
    required this.authorizedLiter,
    required this.balanceLiter,
    required this.orgBalanceLiter,
    required this.status,
    required this.approvalCode,
    required this.transactionRef,
    required this.invoiceId,
    required this.qrRef,
    required this.customerId,
    required this.customerName,
  });
}
