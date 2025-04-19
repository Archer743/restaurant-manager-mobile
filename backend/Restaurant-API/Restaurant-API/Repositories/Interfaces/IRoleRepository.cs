using Restaurant_API.Data.Entities;

namespace Restaurant_API.Repositories.Interfaces
{
	public interface IRoleRepository
	{
		Task<Role?> GetByNormalizedNameAsync(string normalizedName);
	}
}
