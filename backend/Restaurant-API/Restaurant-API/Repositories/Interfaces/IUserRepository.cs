using Restaurant_API.Data.Entities;

namespace Restaurant_API.Repositories.Interfaces
{
	public interface IUserRepository
	{
		Task AddUserAsync(User user);

		Task<User?> GetUserByUsernameAsync(string username);

		Task<User?> GetUserByIdAsync(Guid id);
	}
}
