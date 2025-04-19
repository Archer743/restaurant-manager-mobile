namespace Restaurant_API.Services.Interfaces
{
	public interface IRoleService
	{
		Task<Guid> GetRoleIdByNormalizedNameAsync(string normalizedName);
	}
}
