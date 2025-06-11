using Microsoft.AspNetCore.Mvc;
using Restaurant_API.Data.Models.Reservation;
using Restaurant_API.Services.Interfaces;
using Restaurant_API.Attributes;

namespace Restaurant_API.Controllers
{
    [ApiController]
    [Route("api/r")]
    public class ReservationController : ControllerBase
    {
        private readonly IReservationService reservationService;

        public ReservationController(IReservationService reservationService)
        {
            this.reservationService = reservationService;
        }

        [HttpGet("confirmed"), AppAuthorize]
        public async Task<IActionResult> GetConfirmedReservationsAsync([FromQuery] DateOnly start, [FromQuery] DateOnly end)
        {
            List<ReservationPreview> previews = await reservationService.GetConfirmedReservationsAsync(HttpContext, start, end);
            return Ok(previews);
        }


        [HttpPost("create")]
        public async Task<IActionResult> CreateAsync(ReservationCreateModel createModel)
        {
            await reservationService.CreateAsync(createModel);
            return NoContent();
        }
    }
}
