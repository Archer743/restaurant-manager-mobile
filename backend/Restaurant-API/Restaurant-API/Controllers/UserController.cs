using Microsoft.AspNetCore.Mvc;
using Restaurant_API.Data.Models.User;
using Restaurant_API.Services.Interfaces;

namespace Restaurant_API.Controllers
{
	[ApiController]
	[Route("users")]
	public class UserController : ControllerBase
	{
		private readonly IUserService userService;

		public UserController(IUserService userService)
		{
			this.userService = userService;
		}


		// ======================================================= Authentication Endpoints
		[HttpPost("register")]
		public async Task<IActionResult> RegisterAsync(UserRegisterModel registerModel)
		{
			UserAuthModel auth = await userService.RegisterAsync(registerModel);
			return Ok(auth);
		}

		[HttpPost("login")]
		public async Task<IActionResult> LoginAsync(UserLoginModel loginModel)
		{
			UserAuthModel auth = await userService.LoginAsync(loginModel);
			return Ok(auth);
		}
	}
}
