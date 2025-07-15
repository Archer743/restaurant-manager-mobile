const Map<String, String> errorMessages = {
  // Auth
  "INVALID_AUTHORIZATION": "Невалидна авторизация. Моля, влезте отново.",
  "USER_NOT_FOUND": "Невалидна авторизация. Моля, влезте отново.",
  "FORBIDDEN_ACCESS": "Нямате достъп до тази операция.",

  // Session
  "INVALID_SESSION": "Сесията е невалидна или е изтекла. Моля, влезте отново.",

  // User
  "USERNAME_TAKEN": "Потребителското име вече е заето.",
  "INVALID_CREDENTIALS": "Невалидно потребителско име или парола.",
  "NO_ASSOCIATED_RESTAURANT":
      "Профилът ви не е свързан с ресторант. Моля, свържете се с администратор.",

  // Restaurant
  "RESTAURANT_NOT_FOUND": "Вашият ресторант не е намерен.",

  // Reservation
  "RESERVATION_NOT_FOUND": "Резервацията не е намерена или е изтрита.",
  "RESERVATION_CANNOT_CREATE_IN_PAST":
      "Нямате необходимите права, за да създавате резервации в минал момент.",
  "RESERVATION_CANNOT_MODIFY_TO_PAST":
      "Нямате необходимите права, за да местите резервации в минал момент.",
  "RESERVATION_CANNOT_MODIFY_CLIENT_DETAILS":
      "Детайлите на клиента не могат да бъдат променени.",

  // General
  "INVALID_MODEL":
      "Въведените данни са невалидни. Моля, проверете и опитайте отново.",
  "INVALID_DATE": "Избрана е невалидна дата.",

  // App Error Codes
  "NETWORK": "Проблем с интернет връзката. Моля, опитайте отново.",
  "UNKNOWN": "Нещо се обърка. Моля, опитайте по-късно.",
};
