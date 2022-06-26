class AuthResponse {
  final String accessToken;
  final int statusCode;

  AuthResponse({
    required this.accessToken,
    required this.statusCode,
  });
}

class LoginByRegisterIdResponse {
  final String accessToken;
  final int statusCode;
  final String statusPhrase;

  LoginByRegisterIdResponse({
    required this.accessToken,
    required this.statusCode,
    required this.statusPhrase,
  });
}

