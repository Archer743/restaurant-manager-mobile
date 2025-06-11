using Restaurant_API.Data.Models.Reservation;

namespace Restaurant_API.Services.Interfaces
{
    public interface IReservationService
    {
        Task CreateAsync(ReservationCreateModel createModel);

        Task<List<ReservationPreview>> GetConfirmedReservationsAsync(HttpContext ctx, DateOnly start, DateOnly end);
    }
}
