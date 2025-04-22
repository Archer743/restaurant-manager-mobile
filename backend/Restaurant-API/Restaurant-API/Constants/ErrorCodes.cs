namespace Restaurant_API.Constants
{
	public static class ErrorCodes
	{
		public static class User
		{
			public const string UsernameTaken = "USERNAME_TAKEN";
			public const string InvalidCredentials = "INVALID_CREDENTIALS";
		}

		public static class Session
		{
			public const string InvalidSession = "INVALID_SESSION";
		}

		public static class General
		{
			public const string InvalidModel = "INVALID_MODEL";
		}
	}
}
