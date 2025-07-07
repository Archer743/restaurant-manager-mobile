namespace Restaurant_API.Services.Interfaces
{
	public interface IRoleService
	{
		Task<Guid> GetRoleIdByNormalizedNameAsync(string normalizedName);

		Task<string?> GetUserRoleNormalizedNameByIdAsync(Guid userId);

		bool HasCurrUserRole(HttpContext ctx, string normalizedRole);
    }
}
