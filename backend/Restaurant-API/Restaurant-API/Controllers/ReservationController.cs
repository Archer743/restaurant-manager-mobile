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

        /* ======================================================================== POST */
        [HttpPost]
        public async Task<IActionResult> CreateClientReservationAsync(ClientCreateReservationModel createModel)
        {
            await reservationService.CreateClientReservationAsync(createModel);
            return NoContent();
        }

        [HttpPost("confirmed"), AppAuthorize]
        public async Task<IActionResult> CreateConfirmedReservationAsync(ReservationCreateModel createModel)
        {
            await reservationService.CreateConfirmedReservationAsync(HttpContext, createModel);
            return NoContent();
        }


        /* ======================================================================== GET */
        [HttpGet("{reservationId}"), AppAuthorize]
        public async Task<IActionResult> GetByIdAsync(Guid reservationId)
        {
            ReservationViewModel reservation = await reservationService.GetByIdAsync(HttpContext, reservationId);
            return Ok(reservation);
        }

        [HttpGet("confirmed"), AppAuthorize]
        public async Task<IActionResult> GetConfirmedReservationsInPeriodAsync([FromQuery] DateOnly start, [FromQuery] DateOnly end)
        {
            var previews = await reservationService.GetConfirmedReservationsInPeriodAsync(HttpContext, start, end);
            return Ok(previews);
        }

        [HttpGet("pending"), AppAuthorize]
        public async Task<IActionResult> GetPendingReservationsAsync([FromQuery] PendingReservationsQueryParams queryParams)
        {
            var previews = await reservationService.GetPendingReservationsAsync(HttpContext, queryParams);
            return Ok(previews);
        }


        /* ======================================================================== PATCH */
        [HttpPatch("{reservationId}"), AppAuthorize]
        public async Task<IActionResult> UpdateAsync(Guid reservationId, ReservationUpdateModel updateModel)
        {
            ReservationViewModel reservation = await reservationService.UpdateAsync(HttpContext, reservationId, updateModel);
            return Ok(reservation);
        }
    }
}
