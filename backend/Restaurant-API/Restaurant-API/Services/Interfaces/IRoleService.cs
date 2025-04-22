using Restaurant_API.Repositories;

namespace Restaurant_API.Services.Interfaces
{
	public interface IRoleService
	{
		Task<Guid> GetRoleIdByNormalizedNameAsync(string normalizedName);

		Task<string?> GetUserRoleNormalizedNameByIdAsync(Guid userId);
	}
}
