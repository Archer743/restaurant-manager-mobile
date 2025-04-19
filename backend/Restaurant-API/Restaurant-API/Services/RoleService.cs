using Restaurant_API.Data.Entities;
using Restaurant_API.Repositories.Interfaces;
using Restaurant_API.Services.Interfaces;
using Restaurant_API.Exceptions;

namespace Restaurant_API.Services
{
	public class RoleService : IRoleService
	{
		private readonly IRoleRepository roleRepository;

		public RoleService(IRoleRepository roleRepository)
		{
			this.roleRepository = roleRepository;
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
	}
}
