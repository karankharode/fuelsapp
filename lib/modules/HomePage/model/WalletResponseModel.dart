class WalletResponseModel {
  final SubsidyAccountBalance subsidyAccountBalance;
  final String prepaidAccountBalance;
  final bool success;

  WalletResponseModel({
    required this.subsidyAccountBalance,
    required this.prepaidAccountBalance,
    required this.success,
  });
}

class SubsidyAccountBalance {
  final String createdAt; //: "2022-01-29T03:11:59.401676",
  final String createdBy; //: "admin",
  final String updatedAt; //: "2022-02-16T18:32:05.658403",
  final String updatedBy; //: "posadmin",
  final String id; //: 1,
  final String allocatedLiter; //: 400.000,
  final String availableLiter; //: 18.939,
  final String onholdLiter; //: 5.009,
  final String account; //: "5097721254286",
  final String secureHash; //: "bb5abb1cb198460a5ab2963e35b6ecd0"

  factory SubsidyAccountBalance.fromResponse(Map response) {
    return SubsidyAccountBalance(
      createdAt: response["createdAt"].toString(),
      createdBy: response["createdBy"].toString(),
      updatedAt: response["updatedAt"].toString(),
      updatedBy: response["updatedBy"].toString(),
      id: response["id"].toString(),
      allocatedLiter: response["allocatedLiter"].toString(),
      availableLiter: response["availableLiter"].toString(),
      onholdLiter: response["onholdLiter"].toString(),
      account: response["account"].toString(),
      secureHash: response["secureHash"].toString(),
    );
  }

  SubsidyAccountBalance({
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.id,
    required this.allocatedLiter,
    required this.availableLiter,
    required this.onholdLiter,
    required this.account,
    required this.secureHash,
  });
}

