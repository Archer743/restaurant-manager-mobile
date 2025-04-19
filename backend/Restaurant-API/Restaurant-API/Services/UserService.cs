using Restaurant_API.Constants;
using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Mappers;
using Restaurant_API.Data.Models.User;
using Restaurant_API.Exceptions;
using Restaurant_API.Repositories.Interfaces;
using Restaurant_API.Services.Interfaces;

namespace Restaurant_API.Services
{
	public class UserService : IUserService
	{
		private readonly IRoleService roleService;
		private readonly IJwtService jwtService;
		private readonly IUserRepository userRepository;

		public UserService(IRoleService roleService, IJwtService jwtService, IUserRepository userRepository)
		{
			this.roleService = roleService;
			this.jwtService = jwtService;
			this.userRepository = userRepository;
		}

		public async Task<UserAuthModel> RegisterAsync(UserRegisterModel registerModel)
		{
			if (!await IsUsernameAvailableAsync(registerModel.Username))
			{
				throw new ConflictException(ErrorCodes.User.UsernameTaken);
			}

			User user = registerModel.ToEntity();
			user.Id = Guid.NewGuid();
			user.PasswordHash = GetHashedPassword(registerModel.Password);
			user.RoleId = await roleService.GetRoleIdByNormalizedNameAsync(Roles.Staff);

			// Add a user to the database
			await userRepository.AddUserAsync(user);

			return jwtService.GenerateAuthTokens(user.Id, Roles.Staff);
		}

		public async Task<UserAuthModel> LoginAsync(UserLoginModel loginModel)
		{
			User? user = await userRepository.GetUserByUsernameAsync(loginModel.Username);

			if (user == null || !IsPasswordCorrect(loginModel.Password, user.PasswordHash))
			{
				throw new UnauthorizedException(ErrorCodes.User.InvalidCredentials);
			}

			return jwtService.GenerateAuthTokens(user.Id, user.Role.NormalizedName);
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
