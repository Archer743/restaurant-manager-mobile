abstract class Failure {}

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
class AuthFailure extends Failure {}
