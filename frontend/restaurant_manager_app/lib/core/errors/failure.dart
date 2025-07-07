abstract class Failure {
  /// Determines whether this failure is due to an auth/session problem
  bool get requiresReauthentication =>
      this is AuthTokenFailure || this is InvalidSessionFailure;
}

/// No connection to the server
class NetworkFailure extends Failure {}

/// Unknown exception or 500 status code from the server
class UnknownFailure extends Failure {}

/// Extracted server response for failure
class ServerFailure extends Failure {
  final int statusCode; // HTTP status code
  final String errorCode; // Returned by the server if something went wrong

  ServerFailure({
    required this.errorCode,
    required this.statusCode,
  });
}

/// Auth tokens are invalid or null
class AuthTokenFailure extends Failure {}

class InvalidSessionFailure extends Failure {}
