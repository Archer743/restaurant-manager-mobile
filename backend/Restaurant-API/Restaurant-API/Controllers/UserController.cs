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


		// ======================================================= GET ENDPOINTS
		[HttpPost("register")]
		public async Task<IActionResult> RegisterAsync(UserRegisterModel registerModel)
		{
			// throw new Exception("Test");

			// TODO: Add JWT Support -> Get Access and Refresh Tokens
			// await userService.RegisterAsync(registerModel);

			return Ok();
		}
	}
}
