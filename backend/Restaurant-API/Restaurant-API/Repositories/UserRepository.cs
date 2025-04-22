using Microsoft.EntityFrameworkCore;
using Restaurant_API.Data;
using Restaurant_API.Data.Entities;
using Restaurant_API.Repositories.Interfaces;

namespace Restaurant_API.Repositories
{
	public class UserRepository : IUserRepository
	{
		private readonly AppDbContext context;

		public UserRepository(AppDbContext context)
		{
			this.context = context;
		}

		public async Task AddUserAsync(User user)
		{
			context.Users.Add(user);
			await context.SaveChangesAsync();
		}

		public async Task<User?> GetUserByUsernameAsync(string username)
		{
			return await context.Users
								.Include(user => user.Role)
								.FirstOrDefaultAsync(user => user.Username == username);
		}

		public async Task<User?> GetUserByIdAsync(Guid id)
		{
			return await context.Users
								.Include(user => user.Role)
								.FirstOrDefaultAsync(user => user.Id == id);
		}
	}
}
