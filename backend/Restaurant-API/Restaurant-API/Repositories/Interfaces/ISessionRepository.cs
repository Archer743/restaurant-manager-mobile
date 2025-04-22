using Restaurant_API.Data.Entities;

namespace Restaurant_API.Repositories.Interfaces
{
	public interface ISessionRepository
	{
		Task AddSessionAsync(Session session);

		Task UpdateSessionAsync(Session session);

		Task<Session?> GetSessionByHashedTokenAsync(string refreshTokenHash);
	}
}
