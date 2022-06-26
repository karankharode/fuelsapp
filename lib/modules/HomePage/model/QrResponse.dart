import 'dart:typed_data';

class QRResponse {
  final bool success;
  final Uint8List image;
  final String trxRefId;

  QRResponse(this.success, this.trxRefId, this.image);
}
