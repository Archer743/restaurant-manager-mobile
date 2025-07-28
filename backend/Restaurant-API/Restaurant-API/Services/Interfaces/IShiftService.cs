using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Models.Shift;

namespace Restaurant_API.Services.Interfaces
{
    public interface IShiftService
    {
        Task<ShiftContext> GetShiftContextAsync(Reservation reservation);

        Task<ShiftContext> GetShiftContextAsync(Restaurant restaurant, DateTime dateTimeUtc);

        Task<bool> HasShiftAtTimeAsync(Restaurant restaurant, DateTime dateTimeUtc);

        Task ValidateReservationShiftChangeAsync(Reservation reservation, DateTime newStartTimeUtc);
    }
}
