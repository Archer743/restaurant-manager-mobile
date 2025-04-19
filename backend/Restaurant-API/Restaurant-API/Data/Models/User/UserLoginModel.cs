using Restaurant_API.Attributes;
using System.ComponentModel.DataAnnotations;

namespace Restaurant_API.Data.Models.User
{
	public class UserLoginModel
	{
		[StringLength(40, MinimumLength = 3)]
		public string Username { get; set; }


		[Password]
		public string Password { get; set; }
	}
}
