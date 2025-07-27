namespace Restaurant_API.Constants
{
	public static class ErrorCodes
	{
        public static class Auth
        {
            public const string InvalidAuthorization = "INVALID_AUTHORIZATION";
            public const string UserNotFound = "USER_NOT_FOUND";
            public const string ForbiddenAccess = "FORBIDDEN_ACCESS";
        }

        public static class Session
        {
            public const string InvalidSession = "INVALID_SESSION";
        }

        public static class User
		{
			public const string UsernameTaken = "USERNAME_TAKEN";
			public const string InvalidCredentials = "INVALID_CREDENTIALS";
            public const string NoAssociatedRestaurant = "NO_ASSOCIATED_RESTAURANT";
        }

        public static class Restaurant
        {
            public const string NotFound = "RESTAURANT_NOT_FOUND";
        }

        public static class Table
        {
            public const string NotFound = "TABLE_NOT_FOUND";
            public const string NotPartOfReservation = "TABLE_NOT_PART_OF_RESERVATION";
            public const string BelongsToDifferentRestaurant = "TABLE_DIFFERENT_RESTAURANT";
            public const string AlreadyReserved = "TABLE_ALREADY_RESERVED";
        }

        public static class Reservation
        {
            public const string NotFound = "RESERVATION_NOT_FOUND";
            public const string CannotCreateInPast = "RESERVATION_CANNOT_CREATE_IN_PAST";
            public const string CannotModifyToPast = "RESERVATION_CANNOT_MODIFY_TO_PAST";
            public const string CannotModifyClientDetails = "RESERVATION_CANNOT_MODIFY_CLIENT_DETAILS";
            public const string NoShiftFound = "RESERVATION_NO_SHIFT_FOUND";
            public const string StartTimeOutsideShift = "RESERVATION_START_OUTSIDE_SHIFT";
        }

        public static class Data
		{
            public const string InvalidModel = "INVALID_MODEL";
            public const string InvalidDate = "INVALID_DATE";
		}
	}
}
