abstract class ErrorCodes {
  // ======================================================== Server Error Codes
  // Group: User
  static const String usernameTaken = 'USERNAME_TAKEN';
  static const String invalidCredentials = 'INVALID_CREDENTIALS';
  static const String noAssociatedRestaurant = 'NO_ASSOCIATED_RESTAURANT';

  // Group: Auth
  static const String invalidAuthorization = 'INVALID_AUTHORIZATION';
  static const String forbiddenAccess = 'FORBIDDEN_ACCESS';

  // Group: Session
  static const String invalidSession = 'INVALID_SESSION';

  // Group: General
  static const String invalidModel = 'INVALID_MODEL';

  // ======================================================== App Error Codes
  static const String network = 'NETWORK';
  static const String unknown = 'UNKNOWN';
}
