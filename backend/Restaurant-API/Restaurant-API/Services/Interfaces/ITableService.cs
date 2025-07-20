using Restaurant_API.Data.Models.Shift;
using Restaurant_API.Data.Models.Table;

namespace Restaurant_API.Services.Interfaces
{
    public interface ITableService
    {
        Task<ShiftViewModel> GetTablesAvailabilityForReservationAsync(HttpContext ctx, Guid reservationId);

        Task<ShiftViewModel?> UpdateReservationTablesAsync(HttpContext ctx, Guid reservationId, ReservationTablesUpdate updateModel);
    }
}
