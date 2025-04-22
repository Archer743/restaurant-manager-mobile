using Restaurant_API.Constants;
using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Mappers;
using Restaurant_API.Data.Models.Auth;
using Restaurant_API.Data.Models.User;
using Restaurant_API.Exceptions;
using Restaurant_API.Repositories.Interfaces;
using Restaurant_API.Services.Interfaces;

namespace Restaurant_API.Services
{
    public class UserService : IUserService
	{
		private readonly IRoleService roleService;
		private readonly ISessionService sessionService;
		private readonly IUserRepository userRepository;

		public UserService(IRoleService roleService, ISessionService sessionService, IUserRepository userRepository)
		{
			this.roleService = roleService;
			this.sessionService = sessionService;
			this.userRepository = userRepository;
		}

		public async Task<UserAuthModel> RegisterAsync(UserRegisterModel registerModel)
		{
			if (!await IsUsernameAvailableAsync(registerModel.Username))
			{
				throw new ConflictException(ErrorCodes.User.UsernameTaken);
			}
			
			const string userRole = Roles.Staff;

			// User Setup
			User user = registerModel.ToEntity();
			user.Id = Guid.NewGuid();
			user.PasswordHash = GetHashedPassword(registerModel.Password);
			user.RoleId = await roleService.GetRoleIdByNormalizedNameAsync(userRole);

			// Save the user in the database
			await userRepository.AddUserAsync(user);

			// Create a new session and retrieve the access & refresh tokens
			UserAuthModel tokens = await sessionService.CreateNewSessionAsync(user.Id, userRole);
			return tokens;
		}

		public async Task<UserAuthModel> LoginAsync(UserLoginModel loginModel)
		{
			User? user = await userRepository.GetUserByUsernameAsync(loginModel.Username);

			if (user == null || !IsPasswordCorrect(loginModel.Password, user.PasswordHash))
			{
				throw new UnauthorizedException(ErrorCodes.User.InvalidCredentials);
			}

			// Create a new session and retrieve the access & refresh tokens
			UserAuthModel tokens = await sessionService.CreateNewSessionAsync(user.Id, user.Role.NormalizedName);
			return tokens;
		}

		private async Task<bool> IsUsernameAvailableAsync(string username)
		{
			return (await userRepository.GetUserByUsernameAsync(username)) == null;
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
