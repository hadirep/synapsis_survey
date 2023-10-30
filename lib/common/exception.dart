class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);
}

class ServerException implements Exception {}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);
}