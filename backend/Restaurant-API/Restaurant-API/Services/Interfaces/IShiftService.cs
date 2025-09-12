using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Models.Shift;

namespace Restaurant_API.Services.Interfaces
{
    public interface IShiftService
    {
        Task<Shift> GetByIdAsync(Guid shiftId);

        Task<List<Shift>> GetRestaurantShiftsAsync(Guid restaurantId);

        Task<ShiftContext> GetShiftContextAsync(Reservation reservation);

        Task<HashSet<Guid>> GetReservedTableIdsForShiftAsync(Shift shift, DateOnly localDate, TimeZoneInfo restaurantTimeZone);

        Task<bool> HasShiftAtTimeAsync(Restaurant restaurant, DateTime dateTimeUtc);

        Task ValidateReservationShiftChangeAsync(Reservation reservation, DateTime newStartTimeUtc);
    }
}
