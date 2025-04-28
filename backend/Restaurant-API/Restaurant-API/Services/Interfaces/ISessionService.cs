using Restaurant_API.Data.Models.Auth;

namespace Restaurant_API.Services.Interfaces
{
    public interface ISessionService
	{
		Task<UserAuthModel> CreateNewSessionAsync(Guid userId);

		Task<UserAuthModel> RefreshSessionAsync(string refreshToken);

		Task EndSessionAsync(string refreshToken);

		Task RemoveOldInactiveSessionsAsync();
	}
}
