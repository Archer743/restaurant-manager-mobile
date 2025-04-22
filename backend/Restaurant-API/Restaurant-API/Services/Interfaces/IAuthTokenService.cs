using Restaurant_API.Data.Models.User;

namespace Restaurant_API.Services.Interfaces
{
	public interface IAuthTokenService
	{
		UserAuthModel GenerateAuthTokens(Guid userId, string roleNormalizedName);

		string GenerateAccessToken(Guid userId, string roleNormalizedName);

		string GenerateRefreshToken();
	}
}
