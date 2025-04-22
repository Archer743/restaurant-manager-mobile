using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Restaurant_API.Services.Interfaces;
using Restaurant_API.Settings;
using System.Text;
using Restaurant_API.Exceptions;
using Restaurant_API.Constants;
using System.IdentityModel.Tokens.Jwt;

namespace Restaurant_API.Middlewares
{
	public class AuthenticationMiddleware : BaseAuthMiddleware
	{
		private readonly TokenValidationParameters validParams;
		private readonly IRoleService roleService;

		public AuthenticationMiddleware(RequestDelegate next, IOptions<JwtSettings> settings, IRoleService roleService) : base(next)
		{
			this.roleService = roleService;

			JwtSettings jwtSettings = settings.Value;
			var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings.ServerSecretKey));

			validParams = new TokenValidationParameters
			{
				ValidIssuer = jwtSettings.Issuer,
				ValidAudience = jwtSettings.Audience,
				IssuerSigningKey = key,
				ValidateIssuer = true,
				ValidateAudience = true,
				ValidateIssuerSigningKey = true,
				ValidateLifetime = true
			};
		}

		public async Task InvokeAsync(HttpContext context)
		{
			var endpointAuth = GetEndpointAuthorization(context);

			// Validate if the endpoint requires authentication. If it doesn't => continue with the next middleware
			if (endpointAuth == null)
			{
				await next(context);
				return;
			}

			var handler = new JwtSecurityTokenHandler();

			// All exceptions in this block result in UnauthorizedException for security reasons
			try
			{
				// Attempt to extract the access token from the Authorization header
				string accessToken = GetAccessToken(context);

				// Validate the access token and extract the associated claims
				var claimsPrincipal = handler.ValidateToken(accessToken, validParams, out _);

				// Retrieve the user ID from the token claims
				string userIdClaim = claimsPrincipal.FindFirst("userId")!.Value;

				// Parse the user ID from string to Guid
				Guid userId = Guid.Parse(userIdClaim);

				// Retrieve the user's role - it's normalized name (throws if user does not exist)
				string userRole = await roleService.GetUserRoleNormalizedNameByIdAsync(userId) ?? throw new Exception();

				// Store validated user information for downstream use
				context.Items["UserId"] = userId;
				context.Items["UserRole"] = userRole;  // Needed for authorization
			}
			catch
			{
				throw new UnauthorizedException(ErrorCodes.Auth.InvalidAuthorization);
			}

			await next(context);
		}

		private string GetAccessToken(HttpContext context)
		{
			/*
			 * The request must include an 'Authorization' header following the standard format:
			 * Authorization: Bearer <access_token>
			 *
			 * This ensures the server can extract and validate the JWT access token.
			 */

			// Prevents issues in rare cases where multiple Authorization headers are present
			string? authHeader = context.Request.Headers.Authorization.FirstOrDefault();

			/*
			 * IsNullOrEmpty -> handles only null and ""
			 * IsNullOrWhiteSpace -> handles null, "" and white space chars
			 * StringComparison.OrdinalIgnoreCase -> Ignores casing (Bearer, bearer, BEARER, etc. all match).
			 */

			if (string.IsNullOrWhiteSpace(authHeader) ||
				!authHeader.StartsWith("Bearer ", StringComparison.OrdinalIgnoreCase))
			{
				throw new Exception();
			}

			return authHeader["Bearer ".Length..].Trim();
		}
	}

	public static class AuthenticationMiddlewareExtensions
	{
		public static IApplicationBuilder UseAppAuthentication(this IApplicationBuilder app)
		{
			return app.UseMiddleware<AuthenticationMiddleware>();
		}
	}
}
