class LoginResponse {
  final String customerId;
  final String firstName;
  final String lastName;
  final String companyName;
  final String citizenId;
  final String passportNum;
  final String externalId;
  final String phone;
  final String email;
  final String registrationRegion;
  final String vehicleNo;
  final String customerType;
  final String accountTypeList;
  final String subsidyCode;
  final String mogReportedTime;
  final String issueCard;
  final String cardIssued;
  final String active;
  final String deleted;
  final String cardDamaged;
  final String cardLost;
  final String suspended;
  final String activationFee;
  final String activationEndDate;
  final String subsidyCardExpirydate;
  final String allowedMonthlyLimit;
  final String flow;

  LoginResponse({
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.companyName,
    required this.citizenId,
    required this.passportNum,
    required this.externalId,
    required this.phone,
    required this.email,
    required this.registrationRegion,
    required this.vehicleNo,
    required this.customerType,
    required this.accountTypeList,
    required this.subsidyCode,
    required this.mogReportedTime,
    required this.issueCard,
    required this.cardIssued,
    required this.active,
    required this.deleted,
    required this.cardDamaged,
    required this.cardLost,
    required this.suspended,
    required this.activationFee,
    required this.activationEndDate,
    required this.subsidyCardExpirydate,
    required this.allowedMonthlyLimit,
    required this.flow,
  });

  factory LoginResponse.getUserDetailsLoginResponseFromHttpResponse(Map response) {
    return LoginResponse(
      customerId: response['customerId'].toString(),
      firstName: response['firstName'].toString(),
      lastName: response['lastName'].toString(),
      companyName: response['companyName'].toString(),
      citizenId: response['citizenId'].toString(),
      passportNum: response['passportNum'].toString(),
      externalId: response['externalId'].toString(),
      phone: response['phone'].toString(),
      email: response['email'].toString(),
      registrationRegion: response['registrationRegion'].toString(),
      vehicleNo: response['vehicleNo'].toString(),
      customerType: response['customerType'].toString(),
      accountTypeList: response['accountTypeList'].toString(),
      subsidyCode: response['subsidyCode'].toString(),
      mogReportedTime: response['mogReportedTime'].toString(),
      issueCard: response['issueCard'].toString(),
      cardIssued: response['cardIssued'].toString(),
      active: response['active'].toString(),
      deleted: response['deleted'].toString(),
      cardDamaged: response['cardDamaged'].toString(),
      cardLost: response['cardLost'].toString(),
      suspended: response['suspended'].toString(),
      activationFee: response['activationFee'].toString(),
      activationEndDate: response['activationEndDate'].toString(),
      subsidyCardExpirydate: response['subsidyCardExpirydate'].toString(),
      allowedMonthlyLimit: response['allowedMonthlyLimit'].toString(),
      flow: response['flow'].toString(),
    );
  }

  factory LoginResponse.fromJson(Map<String, dynamic> response) {
    return LoginResponse(
      customerId: response['customerId'].toString(),
      firstName: response['firstName'].toString(),
      lastName: response['lastName'].toString(),
      companyName: response['companyName'].toString(),
      citizenId: response['citizenId'].toString(),
      passportNum: response['passportNum'].toString(),
      externalId: response['externalId'].toString(),
      phone: response['phone'].toString(),
      email: response['email'].toString(),
      registrationRegion: response['registrationRegion'].toString(),
      vehicleNo: response['vehicleNo'].toString(),
      customerType: response['customerType'].toString(),
      accountTypeList: response['accountTypeList'].toString(),
      subsidyCode: response['subsidyCode'].toString(),
      mogReportedTime: response['mogReportedTime'].toString(),
      issueCard: response['issueCard'].toString(),
      cardIssued: response['cardIssued'].toString(),
      active: response['active'].toString(),
      deleted: response['deleted'].toString(),
      cardDamaged: response['cardDamaged'].toString(),
      cardLost: response['cardLost'].toString(),
      suspended: response['suspended'].toString(),
      activationFee: response['activationFee'].toString(),
      activationEndDate: response['activationEndDate'].toString(),
      subsidyCardExpirydate: response['subsidyCardExpirydate'].toString(),
      allowedMonthlyLimit: response['allowedMonthlyLimit'].toString(),
      flow: response['flow'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    return {
      data["customerId"]: this.customerId,
      data["firstName"]: this.firstName,
      data["lastName"]: this.lastName,
      data["companyName"]: this.companyName,
      data["citizenId"]: this.citizenId,
      data["passportNum"]: this.passportNum,
      data["externalId"]: this.externalId,
      data["phone"]: this.phone,
      data["email"]: this.email,
      data["registrationRegion"]: this.registrationRegion,
      data["vehicleNo"]: this.vehicleNo,
      data["customerType"]: this.customerType,
      data["accountTypeList"]: this.accountTypeList,
      data["subsidyCode"]: this.subsidyCode,
      data["mogReportedTime"]: this.mogReportedTime,
      data["issueCard"]: this.issueCard,
      data["cardIssued"]: this.cardIssued,
      data["active"]: this.active,
      data["deleted"]: this.deleted,
      data["cardDamaged"]: this.cardDamaged,
      data["cardLost"]: this.cardLost,
      data["suspended"]: this.suspended,
      data["activationFee"]: this.activationFee,
      data["activationEndDate"]: this.activationEndDate,
      data["subsidyCardExpirydate"]: this.subsidyCardExpirydate,
      data["allowedMonthlyLimit"]: this.allowedMonthlyLimit,
      data["flow"]: this.flow,
    };
  }
}
