using Microsoft.AspNetCore.Mvc;
using Restaurant_API.Attributes;
using Restaurant_API.Services.Interfaces;

namespace Restaurant_API.Controllers
{
    [ApiController]
    [Route("api/users")]
    public class UserController : ControllerBase
    {
        private readonly IUserService userService;

        public UserController(IUserService userService)
        {
            this.userService = userService;
        }

        /* ======================================================================== GET */
        [HttpGet("current"), AppAuthorize]
        public async Task<IActionResult> GetCurrUserProfileAsync()
        {
            var profileView = await userService.GetCurrUserProfileAsync(HttpContext);
            return Ok(profileView);
        }
    }
}
