import 'package:restaurant_manager_app/core/constants/error_codes.dart';

import 'failure.dart';
import '../constants/error_messages.dart';

String getFailureMessage(Failure failure) {
  if (failure is ServerFailure) {
    return errorMessages[failure.errorCode]!;
  } else if (failure is NetworkFailure) {
    return errorMessages[ErrorCodes.network]!;
  } else if (failure is AuthTokenFailure || failure is InvalidSessionFailure) {
    return errorMessages[ErrorCodes.invalidSession]!;
  }

  return errorMessages[ErrorCodes.unknown]!;
}

String getErrorMessage(String errorCode) {
  return errorMessages[errorCode] ?? errorMessages[ErrorCodes.unknown]!;
}
