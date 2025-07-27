using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Models.Shift;

namespace Restaurant_API.Services.Interfaces
{
    public interface IShiftService
    {
        Task<ReservationShiftContext> GetReservationShiftContextAsync(Reservation reservation);

        Task<bool> HasShiftAtTimeAsync(Restaurant restaurant, DateTime dateTimeUtc);
    }
}
