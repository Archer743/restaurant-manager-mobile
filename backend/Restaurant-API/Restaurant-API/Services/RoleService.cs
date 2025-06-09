using Restaurant_API.Data.Entities;
using Restaurant_API.Repositories.Interfaces;
using Restaurant_API.Services.Interfaces;

namespace Restaurant_API.Services
{
	public class RoleService : IRoleService
	{
		private readonly IRoleRepo roleRepo;
		private readonly IUserRepo userRepo;

		public RoleService(IRoleRepo roleRepo, IUserRepo userRepo)
		{
			this.roleRepo = roleRepo;
			this.userRepo = userRepo;
		}

		public async Task<Guid> GetRoleIdByNormalizedNameAsync(string normalizedName)
		{
			Role? role = await roleRepo.GetByNormalizedNameAsync(normalizedName);

			if (role == null)
			{
				throw new Exception($"A role with normalized name '{normalizedName}' was not found in the database.");
			}

			return role.Id;
		}

		public async Task<string?> GetUserRoleNormalizedNameByIdAsync(Guid userId)
		{
			User? user = await userRepo.GetByIdAsync(userId);
			return user?.Role.NormalizedName;
		}
	}
}
