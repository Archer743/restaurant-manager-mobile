using Restaurant_API.Data.Models.User;

namespace Restaurant_API.Services.Interfaces
{
	public interface IUserService
	{
		Task RegisterAsync(UserRegisterModel registerModel);
	}
}
