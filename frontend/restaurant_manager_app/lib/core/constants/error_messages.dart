import 'package:restaurant_manager_app/core/constants/error_codes.dart';

const Map<String, String> errorMessages = {
  // Auth
  ErrorCodes.invalidAuthorization:
      "Невалидна авторизация. Моля, влезте отново.",
  ErrorCodes.userNotFound: "Невалидна авторизация. Моля, влезте отново.",
  ErrorCodes.forbiddenAccess: "Нямате достъп до тази операция.",

  // Session
  ErrorCodes.invalidSession:
      "Сесията е невалидна или е изтекла. Моля, влезте отново.",

  // User
  ErrorCodes.usernameTaken: "Потребителското име вече е заето.",
  ErrorCodes.invalidCredentials: "Невалидно потребителско име или парола.",
  ErrorCodes.noAssociatedRestaurant:
      "Профилът ви не е свързан с ресторант. Моля, свържете се с администратор.",

  // Restaurant
  ErrorCodes.restaurantNotFound: "Вашият ресторант не е намерен.",
  ErrorCodes.restaurantNoShiftsFound: "Няма намерени смени за ресторанта.",

  // Shift
  ErrorCodes.shiftNotFound: "Смяната не е намерена.",
  ErrorCodes.shiftBelongsToDifferentRestaurant:
      "Смяната не принадлежи на този ресторант.",

  // Table
  ErrorCodes.tableNotFound: "Някоя от избраните маси не беше намерена.",
  ErrorCodes.tableNotPartOfReservation:
      "Някоя от избраните маси вече не е част от резервацията.",
  ErrorCodes.tableDifferentRestaurant:
      "Избрана е маса, която принадлежи към друг ресторант.",
  ErrorCodes.tableAlreadyReserved:
      "Някоя от избраните маси вече е заета за този период.",
  ErrorCodes.tableReservedInNewShift:
      "Не може да преместите резервацията – част от масите са вече заети в новата смяна.",
  ErrorCodes.cannotModifyTablesOfClosedReservation:
      "Не може да променяте масите на приключена резервация.",

  // Reservation
  ErrorCodes.reservationNotFound: "Резервацията не е намерена или е изтрита.",
  ErrorCodes.reservationCannotCreateInPast:
      "Нямате необходимите права, за да създавате резервации в минал момент.",
  ErrorCodes.reservationCannotModifyToPast:
      "Нямате необходимите права, за да местите резервации в минал момент.",
  ErrorCodes.reservationCannotModifyClientDetails:
      "Детайлите на клиента не могат да бъдат променени.",
  ErrorCodes.reservationStartTimeOutsideShift:
      "Избраните дата и час са извън работното време на ресторанта.",
  ErrorCodes.reservationOutsideShift:
      "Резервацията е извън работното време на ресторанта.",
  ErrorCodes.reservationAlreadyClosed: "Резервацията е вече приключена.",
  ErrorCodes.reservationAlreadyActive: "Резервацията е вече активна.",
  ErrorCodes.closedReservationTablesUnavailable:
      "Масите не са налични. Резервацията е приключена.",

  // General
  ErrorCodes.invalidModel:
      "Въведените данни са невалидни. Моля, проверете и опитайте отново.",
  ErrorCodes.invalidDate: "Избрана е невалидна дата.",

  // App Error Codes
  ErrorCodes.network: "Проблем с интернет връзката. Моля, опитайте отново.",
  ErrorCodes.unknown: "Нещо се обърка. Моля, опитайте по-късно.",
};
