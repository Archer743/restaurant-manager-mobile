using Restaurant_API.Data.Models.User;

namespace Restaurant_API.Services.Interfaces
{
	public interface IJwtService
	{
		UserAuthModel GenerateUserTokens(Guid userId, string roleNormalizedName);

		string GenerateNewAccessToken(Guid userId, string roleNormalizedName);

		string GenerateNewRefreshToken(Guid userId);
	}
}
