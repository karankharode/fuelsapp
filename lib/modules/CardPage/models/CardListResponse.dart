class CardListResponse {
  final List<CardModel> cardList;
  final bool success;

  CardListResponse({
    required this.cardList,
    required this.success,
  });

  factory CardListResponse.fromResponse(List response) {
    List<CardModel> cardList = [];
    for (var i = 0; i < response.length; i++) {
      CardModel cardModel = CardModel.fromResponse(response[i]);
      cardList.add(cardModel);
    }
    return CardListResponse(cardList: cardList, success: true);
  }
}

class CardModel {
  final String cardNo; // "8010100001020010",
  final String cardType; // "NFC",
  final String cardProduct; // "DISCOUNT",
  final String active; // true,
  final String suspended; // null,
  final String damaged; // null,
  final String deleted; // null,
  final String lost; // null,
  final String stolen; // null,
  final String startDate; // "2022-01-29T03:17:22.499198",
  final String endDate; // null,
  final String activatedStationId; // "999001",
  final String activatedTime; // "2022-01-29T03:17:22.499212"

  factory CardModel.fromResponse(Map response) {
    return CardModel(
      cardNo: response["cardNo"].toString(),
      cardType: response["cardType"].toString(),
      cardProduct: response["cardProduct"].toString(),
      active: response["active"].toString(),
      suspended: response["suspended"].toString(),
      damaged: response["damaged"].toString(),
      deleted: response["deleted"].toString(),
      lost: response["lost"].toString(),
      stolen: response["stolen"].toString(),
      startDate: response["startDate"].toString(),
      endDate: response["endDate"].toString(),
      activatedStationId: response["activatedStationId"].toString(),
      activatedTime: response["activatedTime"].toString(),
    );
  }

  CardModel(
      {required this.cardNo,
      required this.cardType,
      required this.cardProduct,
      required this.active,
      required this.suspended,
      required this.damaged,
      required this.deleted,
      required this.lost,
      required this.stolen,
      required this.startDate,
      required this.endDate,
      required this.activatedStationId,
      required this.activatedTime});
}
