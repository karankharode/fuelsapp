class StationListResponse {
  final List<StationModel> stationList;
  final bool success;

  StationListResponse({
    required this.stationList,
    required this.success,
  });

  factory StationListResponse.fromResponse(List response) {
    List<StationModel> cardList = [];
    for (var i = 0; i < response.length; i++) {
      StationModel stationModel = StationModel.fromResponse(response[i]);
      cardList.add(stationModel);
    }
    return StationListResponse(stationList: cardList, success: true);
  }
}

class StationModel {
  final String createdAt; // null,
  final String createdBy; // null,
  final String updatedAt; // null,
  final String updatedBy; // null,
  final String id; // 1,
  final String stationId; // "999001",
  final String name; // "STATION1",
  final String reference; // "Muscat",
  final String address; // "Muscat",
  final String region; // "Muscat",
  final String wilayat; // "Muscat",
  final String contact_no; // "+96845678862",
  final String vatIn; // null,
  final String email; // "station1@almaha.com",
  final String latitude; // 0.0,
  final String longitude; // 0.0,
  final String active; // true,
  final String carWash; // null,
  final String cstore; // null,
  final String atm; // null,
  final String fuelM98; // null,
  final String repairWorkshop; // null,
  final String merchantId; // "999"

  factory StationModel.fromResponse(Map response) {
    return StationModel(
      createdAt: response["createdAt"].toString(),
      createdBy: response["createdBy"].toString(),
      updatedAt: response["updatedAt"].toString(),
      updatedBy: response["updatedBy"].toString(),
      id: response["id"].toString(),
      stationId: response["stationId"].toString(),
      name: response["name"].toString(),
      reference: response["reference"].toString(),
      address: response["address"].toString(),
      region: response["region"].toString(),
      wilayat: response["wilayat"].toString(),
      contact_no: response["contact_no"].toString(),
      vatIn: response["vatIn"].toString(),
      email: response["email"].toString(),
      latitude: response["latitude"].toString(),
      longitude: response["longitude"].toString(),
      active: response["active"].toString(),
      carWash: response["carWash"].toString(),
      cstore: response["cstore"].toString(),
      atm: response["atm"].toString(),
      fuelM98: response["fuelM98"].toString(),
      repairWorkshop: response["repairWorkshop"].toString(),
      merchantId: response["merchantId"].toString(),
    );
  }

  StationModel({
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.id,
    required this.stationId,
    required this.name,
    required this.reference,
    required this.address,
    required this.region,
    required this.wilayat,
    required this.contact_no,
    required this.vatIn,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.active,
    required this.carWash,
    required this.cstore,
    required this.atm,
    required this.fuelM98,
    required this.repairWorkshop,
    required this.merchantId,
  });
}
