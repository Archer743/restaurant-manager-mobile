using Microsoft.AspNetCore.Mvc;
using Restaurant_API.Data.Models.Reservation;
using Restaurant_API.Services.Interfaces;

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

        [HttpPost("create")]
        public async Task<IActionResult> CreateAsync(ReservationCreateModel createModel)
        {
            await reservationService.CreateAsync(createModel);
            return NoContent();
        }
    }
}
