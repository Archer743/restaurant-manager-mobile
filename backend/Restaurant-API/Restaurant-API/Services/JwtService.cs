using Microsoft.IdentityModel.Tokens;
using Microsoft.Extensions.Options;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Restaurant_API.Services.Interfaces;
using Restaurant_API.Settings;
using Restaurant_API.Data.Models.User;

namespace Restaurant_API.Services
{
	public class JwtService : IJwtService
	{
		private readonly JwtSettings jwtSettings;

		public JwtService(IOptions<JwtSettings> settings)
		{
			jwtSettings = settings.Value;
		}

		public UserAuthModel GenerateAuthTokens(Guid userId, string roleNormalizedName)
		{
			return new UserAuthModel
			{
				AccessToken = GenerateNewAccessToken(userId, roleNormalizedName),
				RefreshToken = GenerateNewRefreshToken(userId)
			};
		}

		public string GenerateNewAccessToken(Guid userId, string roleNormalizedName)
		{
			var expiration = DateTime.UtcNow.Add(jwtSettings.AccessTokenLifetime);

			Claim[] claims = [
				new Claim("userId", userId.ToString()),
				new Claim("userRole", roleNormalizedName)
			];

			return GenerateNewJwtToken(expiration, claims);
		}

		public string GenerateNewRefreshToken(Guid userId)
		{
			var expiration = DateTime.UtcNow.Add(jwtSettings.RefreshTokenLifetime);

			Claim[] claims = [
				new Claim("userId", userId.ToString())
			];

			return GenerateNewJwtToken(expiration, claims);
		}

		private string GenerateNewJwtToken(DateTime expiration, Claim[] claims)
		{
			var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings.ServerSecretKey));

			var token = new JwtSecurityToken(
				issuer: jwtSettings.Issuer,
				audience: jwtSettings.Audience,
				claims: claims,
				expires: expiration,
				signingCredentials: new SigningCredentials(key, SecurityAlgorithms.HmacSha256)
			);

			var tokenHandler = new JwtSecurityTokenHandler();

			return tokenHandler.WriteToken(token);
		}
	}
}
