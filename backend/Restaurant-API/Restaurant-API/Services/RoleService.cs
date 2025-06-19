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

        public bool HasCurrUserRole(HttpContext ctx, string normalizedRole)
        {
            // Attempt to retrieve the role set by the authentication middleware
            string? currUserRole = ctx.Items["UserRole"] as string;

            // If no role is present, this likely means the endpoint doesn't require authenticated access.
            if (currUserRole == null)
            {
                throw new InvalidOperationException("User role is not set in the current context. This method should only be called on authenticated endpoints.");
            }

            return currUserRole == normalizedRole;
        }
    }
}
