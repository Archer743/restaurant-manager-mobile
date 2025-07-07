using Restaurant_API.Constants;
using Restaurant_API.Exceptions;

namespace Restaurant_API.Middlewares
{
	public class AuthorizationMiddleware : BaseAuthMiddleware
	{
		public AuthorizationMiddleware(RequestDelegate next) : base(next) { }

		public async Task InvokeAsync(HttpContext context)
		{
			var endpointAuth = GetEndpointAuthorization(context);

			// Validate if the endpoint requires authorization
			if (endpointAuth == null || endpointAuth.Roles.Length == 0)
			{
				await next(context);
				return;
			}

			// The userRole is expected to be set by AuthenticationMiddleware.
			// Middleware ordering is critical: AuthenticationMiddleware must run before this one.
			if (context.Items["UserRole"] is not string userRole)
			{
				throw new InvalidOperationException("UserRole not found in HttpContext.Items. Ensure AuthenticationMiddleware is executed before AuthorizationMiddleware.");
			}

			if (!endpointAuth.Roles.Contains(userRole))
			{
				throw new ForbiddenException();
			}

			await next(context);
		}
	}

	public static class AuthorizationMiddlewareExtensions
	{
		public static IApplicationBuilder UseAppAuthorization(this IApplicationBuilder app)
		{
			return app.UseMiddleware<AuthorizationMiddleware>();
		}
	}
}
