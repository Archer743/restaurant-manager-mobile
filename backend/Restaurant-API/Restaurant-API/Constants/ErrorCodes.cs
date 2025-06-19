namespace Restaurant_API.Constants
{
	public static class ErrorCodes
	{
        public static class Auth
        {
            public const string InvalidAuthorization = "INVALID_AUTHORIZATION";
            public const string UserNotFound = "USER_NOT_FOUND";

            // Permissions
            public const string ForbiddenAccess = "FORBIDDEN_ACCESS";
            public const string CannotModifyToPast = "AUTH_CANNOT_SET_PAST_DATETIME";
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

        public static class Reservation
        {
            public const string NotFound = "RESERVATION_NOT_FOUND";
        }

        public static class Data
		{
            public const string InvalidModel = "INVALID_MODEL";
            public const string InvalidDate = "INVALID_DATE";
		}
	}
}
