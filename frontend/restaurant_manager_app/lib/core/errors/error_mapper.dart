import 'failure.dart';
import '../constants/error_messages.dart';

String getErrorMessage(Failure failure) {
  if (failure is ServerFailure) {
    return errorMessages[failure.errorCode]!;
  } else if (failure is NetworkFailure) {
    return errorMessages['NETWORK']!;
  }

  return errorMessages['UNKNOWN']!;
}
