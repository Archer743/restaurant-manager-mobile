using Restaurant_API.Data.Entities;
using Restaurant_API.Repositories.Interfaces;
using Restaurant_API.Services.Interfaces;

namespace Restaurant_API.Services
{
	public class RoleService : IRoleService
	{
		private readonly IRoleRepository roleRepository;
		private readonly IUserRepository userRepository;

		public RoleService(IRoleRepository roleRepository, IUserRepository userRepository)
		{
			this.roleRepository = roleRepository;
			this.userRepository = userRepository;
		}

		public async Task<Guid> GetRoleIdByNormalizedNameAsync(string normalizedName)
		{
			Role? role = await roleRepository.GetByNormalizedNameAsync(normalizedName);

			if (role == null)
			{
				throw new Exception($"A role with normalized name '{normalizedName}' was not found in the database.");
			}

			return role.Id;
		}

		public async Task<string?> GetUserRoleNormalizedNameByIdAsync(Guid userId)
		{
			User? user = await userRepository.GetUserByIdAsync(userId);
			return user?.Role.NormalizedName;
		}
	}
}
