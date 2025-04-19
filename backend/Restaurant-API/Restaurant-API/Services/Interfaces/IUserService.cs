using Restaurant_API.Data.Models.User;

namespace Restaurant_API.Services.Interfaces
{
	public interface IUserService
	{
		Task<UserAuthModel> RegisterAsync(UserRegisterModel registerModel);

		Task<UserAuthModel> LoginAsync(UserLoginModel loginModel);
	}
}
