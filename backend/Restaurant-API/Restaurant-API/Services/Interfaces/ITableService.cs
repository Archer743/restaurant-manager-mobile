using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Models.Shift;
using Restaurant_API.Data.Models.Table;

namespace Restaurant_API.Services.Interfaces
{
    public interface ITableService
    {
        Task<ShiftViewModel?> GetTablesAvailabilityForReservationAsync(HttpContext ctx, Guid reservationId);
    }
}
