using Restaurant_API.Data.Models.User;

namespace Restaurant_API.Services.Interfaces
{
	public interface IJwtService
	{
		UserAuthModel GenerateAuthTokens(Guid userId, string roleNormalizedName);

		string GenerateNewAccessToken(Guid userId, string roleNormalizedName);

		string GenerateNewRefreshToken(Guid userId);
	}
}
