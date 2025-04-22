namespace Restaurant_API.Attributes
{
	[AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]
	public class AppAuthorizeAttribute : Attribute
	{
		public string[] Roles { get; init; }

		// params -> lets you pass a variable number of arguments to a method
		public AppAuthorizeAttribute(params string[] roles)
		{
			Roles = roles;
		}
	}
}
