using Restaurant_API.Constants;
using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Models.Shift;
using Restaurant_API.Exceptions;
using Restaurant_API.Repositories.Interfaces;
using Restaurant_API.Services.Interfaces;

namespace Restaurant_API.Services
{
    public class ShiftService : IShiftService
    {
        private readonly IRestaurantService restaurantService;

        private readonly IShiftRepo shiftRepo;
        private readonly IReservationRepo reservationRepo;

        public ShiftService(IRestaurantService restaurantService, IShiftRepo shiftRepo, IReservationRepo reservationRepo)
        {
            this.restaurantService = restaurantService;

            this.shiftRepo = shiftRepo;
            this.reservationRepo = reservationRepo;
        }

        public async Task<ReservationShiftContext> GetReservationShiftContextAsync(Reservation reservation)
        {
            // 1. Get the restaurant's time zone
            var restaurantTimeZone = restaurantService.GetTimeZoneInfo(reservation.Restaurant);

            // 2. Convert the reservation start time to restaurant's local time
            var reservationStartLocal = TimeZoneInfo.ConvertTimeFromUtc(reservation.StartTimeUtc, restaurantTimeZone);
            var localTime = TimeOnly.FromDateTime(reservationStartLocal);
            var localDate = DateOnly.FromDateTime(reservationStartLocal);

            // 3. Find the shift that covers this local time
            var shift = await shiftRepo.GetRestaurantShiftAtTimeAsync(reservation.RestaurantId, localTime) ??
                                        throw new NotFoundException(ErrorCodes.Reservation.NoShiftFound);

            // 4. Calculate shift start and end in UTC for that date
            var shiftStartUtc = TimeZoneInfo.ConvertTimeToUtc(localDate.ToDateTime(shift.StartTime), restaurantTimeZone);
            var shiftEndUtc = TimeZoneInfo.ConvertTimeToUtc(localDate.ToDateTime(shift.EndTime), restaurantTimeZone);

            // 5. Get all table IDs reserved in this shift
            var reservedTableIds = await reservationRepo.GetReservedTableIdsInPeriodAsync(
                reservation.RestaurantId,
                shiftStartUtc,
                shiftEndUtc);

            return new ReservationShiftContext
            {
                Shift = shift,
                ReservedTableIds = reservedTableIds,
            };
        }

        public async Task<bool> HasShiftAtTimeAsync(Restaurant restaurant, DateTime dateTimeUtc)
        {
            // 1. Get the restaurant's time zone
            var restaurantTimeZone = restaurantService.GetTimeZoneInfo(restaurant);

            // 2. Convert Utc DateTime to restaurant's local time
            var dateTimeLocal = TimeZoneInfo.ConvertTimeFromUtc(dateTimeUtc, restaurantTimeZone);
            var localTime = TimeOnly.FromDateTime(dateTimeLocal);

            // 3. Find the shift that covers this local time
            var shift = await shiftRepo.GetRestaurantShiftAtTimeAsync(restaurant.Id, localTime);

            return shift != null;
        }
    }
}
