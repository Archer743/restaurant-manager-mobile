using Restaurant_API.Constants;
using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Mappers;
using Restaurant_API.Data.Models.Auth;
using Restaurant_API.Data.Models.User;
using Restaurant_API.Exceptions;
using Restaurant_API.Extensions;
using Restaurant_API.Repositories.Interfaces;
using Restaurant_API.Services.Interfaces;

namespace Restaurant_API.Services
{
    public class UserService : IUserService
	{
		private readonly IRoleService roleService;
		private readonly ISessionService sessionService;
		private readonly IUserRepo userRepo;

		public UserService(IRoleService roleService, ISessionService sessionService, IUserRepo userRepo)
		{
			this.roleService = roleService;
			this.sessionService = sessionService;
			this.userRepo = userRepo;
		}

		public async Task<UserAuthModel> RegisterAsync(UserRegisterModel registerModel)
		{
			if (!await IsUsernameAvailableAsync(registerModel.Username))
			{
				throw new ConflictException(ErrorCodes.User.UsernameTaken);
			}
			
			// User Setup
			User user = registerModel.ToEntity();
			user.Id = Guid.NewGuid();
			user.PasswordHash = GetHashedPassword(registerModel.Password);
			user.RoleId = await roleService.GetRoleIdByNormalizedNameAsync(Roles.Staff);

			// Save the user in the database
			await userRepo.AddAsync(user);

			// Create a new session and retrieve the access & refresh tokens
			UserAuthModel tokens = await sessionService.CreateNewSessionAsync(user.Id);
			return tokens;
		}

		public async Task<UserAuthModel> LoginAsync(UserLoginModel loginModel)
		{
			User? user = await userRepo.GetByUsernameAsync(loginModel.Username);

			if (user == null || !IsPasswordCorrect(loginModel.Password, user.PasswordHash))
			{
				throw new UnauthorizedException(ErrorCodes.User.InvalidCredentials);
			}

			// Create a new session and retrieve the access & refresh tokens
			UserAuthModel tokens = await sessionService.CreateNewSessionAsync(user.Id);
			return tokens;
		}

		public UserProfileViewModel GetCurrUserProfile(HttpContext ctx)
		{
			return ctx.GetCurrUser().ToProfileView();
		}

        private async Task<bool> IsUsernameAvailableAsync(string username)
		{
			return (await userRepo.GetByUsernameAsync(username)) == null;
		}

		private string GetHashedPassword(string password)
		{
			return BCrypt.Net.BCrypt.EnhancedHashPassword(password, 13);
		}

		private bool IsPasswordCorrect(string plainPassword, string hashedPassword)
		{
			return BCrypt.Net.BCrypt.EnhancedVerify(plainPassword, hashedPassword);
		}
	}
}
