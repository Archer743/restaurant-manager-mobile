using Restaurant_API.Data.Models.Reservation;

namespace Restaurant_API.Services.Interfaces
{
    public interface IReservationService
    {
        Task CreateClientReservationAsync(ClientReservationCreateModel createModel);

        Task CreateConfirmedReservationAsync(HttpContext ctx, ReservationCreateModel createModel);

        Task<Dictionary<DateOnly, List<ReservationPreviewModel>>> GetConfirmedReservationsAsync(HttpContext ctx, DateOnly start, DateOnly end);

        Task<ReservationViewModel> GetByIdAsync(HttpContext ctx, Guid reservationId);

        Task<ReservationViewModel> UpdateAsync(HttpContext ctx, Guid reservationId, ReservationUpdateModel updateModel);
    }
}
