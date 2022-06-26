class GenerateOTPResponse {
  final String otpMobileNo;
  final String phone;
  final String otpRef;
  final bool otpSent;
  final bool civilNumberVerified;
  final String flow;

  GenerateOTPResponse({
    required this.otpMobileNo,
    required this.phone,
    required this.flow,
    required this.otpRef,
    required this.otpSent,
    required this.civilNumberVerified,
  });
}
class RegisterUserResponse {
  final bool status;

  RegisterUserResponse({
    required this.status,
  });
}
