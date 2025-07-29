abstract class ErrorCodes {
  // ======================== Server Error Codes
  // Auth
  static const String invalidAuthorization = 'INVALID_AUTHORIZATION';
  static const String userNotFound = 'USER_NOT_FOUND';
  static const String forbiddenAccess = 'FORBIDDEN_ACCESS';

  // Session
  static const String invalidSession = 'INVALID_SESSION';

  // User
  static const String usernameTaken = 'USERNAME_TAKEN';
  static const String invalidCredentials = 'INVALID_CREDENTIALS';
  static const String noAssociatedRestaurant = 'NO_ASSOCIATED_RESTAURANT';

  // Restaurant
  static const String restaurantNotFound = 'RESTAURANT_NOT_FOUND';

  // Table
  static const String tableNotFound = 'TABLE_NOT_FOUND';
  static const String tableNotPartOfReservation =
      'TABLE_NOT_PART_OF_RESERVATION';
  static const String tableDifferentRestaurant = 'TABLE_DIFFERENT_RESTAURANT';
  static const String tableAlreadyReserved = 'TABLE_ALREADY_RESERVED';
  static const String tableReservedInNewShift = 'TABLE_RESERVED_IN_NEW_SHIFT';

  // Reservation
  static const String reservationNotFound = 'RESERVATION_NOT_FOUND';
  static const String reservationCannotCreateInPast =
      'RESERVATION_CANNOT_CREATE_IN_PAST';
  static const String reservationCannotModifyToPast =
      'RESERVATION_CANNOT_MODIFY_TO_PAST';
  static const String reservationCannotModifyClientDetails =
      'RESERVATION_CANNOT_MODIFY_CLIENT_DETAILS';
  static const String reservationStartTimeOutsideShift =
      'RESERVATION_START_OUTSIDE_SHIFT';
  static const String reservationOutsideShift = 'RESERVATION_OUTSIDE_SHIFT';

  // Data
  static const String invalidModel = 'INVALID_MODEL';
  static const String invalidDate = 'INVALID_DATE';

  // ======================== App Error Codes
  static const String network = 'NETWORK';
  static const String unknown = 'UNKNOWN';
}
