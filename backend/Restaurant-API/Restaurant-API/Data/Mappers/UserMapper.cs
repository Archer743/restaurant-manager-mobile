using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Models.User;

namespace Restaurant_API.Data.Mappers
{
	public static class UserMapper
	{
		public static User ToEntity(this UserRegisterModel registerModel)
		{
			return new User
			{
				Username = registerModel.Username,
				FirstName = registerModel.FirstName,
				LastName = registerModel.LastName
				// Id, PasswordHash and RoleId are set in UserService
			};
		}
	}
}
