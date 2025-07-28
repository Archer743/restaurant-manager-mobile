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

        public async Task<ShiftContext> GetShiftContextAsync(Reservation reservation)
        {
            return await GetShiftContextAsync(reservation.Restaurant, reservation.StartTimeUtc);
        }

        public async Task<ShiftContext> GetShiftContextAsync(Restaurant restaurant, DateTime dateTimeUtc)
        {
            // 1. Get the restaurant's time zone
            var restaurantTimeZone = restaurantService.GetTimeZoneInfo(restaurant);

            // 2. Convert the reservation start time to restaurant's local time
            var dateTimeLocal = TimeZoneInfo.ConvertTimeFromUtc(dateTimeUtc, restaurantTimeZone);
            var localTime = TimeOnly.FromDateTime(dateTimeLocal);
            var localDate = DateOnly.FromDateTime(dateTimeLocal);

            // TODO: Fix Error Code
            // 3. Find the shift that covers this local time
            var shift = await shiftRepo.GetRestaurantShiftAtTimeAsync(restaurant.Id, localTime) ??
                                        throw new NotFoundException(ErrorCodes.Reservation.NoShiftFound);

            // 4. Calculate shift start and end in UTC for that date
            var shiftStartUtc = TimeZoneInfo.ConvertTimeToUtc(localDate.ToDateTime(shift.StartTime), restaurantTimeZone);
            var shiftEndUtc = TimeZoneInfo.ConvertTimeToUtc(localDate.ToDateTime(shift.EndTime), restaurantTimeZone);

            // 5. Get all table IDs reserved in this shift
            var reservedTableIds = await reservationRepo.GetReservedTableIdsInPeriodAsync(
                restaurant.Id,
                shiftStartUtc,
                shiftEndUtc);

            return new ShiftContext
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

        public async Task ValidateReservationShiftChangeAsync(Reservation reservation, DateTime newStartTimeUtc)
        {
            var newShiftCtx = await GetShiftContextAsync(reservation.Restaurant, newStartTimeUtc);

            var currTableIds = reservation.Tables.Select(t => t.Id);
            var conflicts = currTableIds.Intersect(newShiftCtx.ReservedTableIds).ToList();

            if (conflicts.Any())
            {
                throw new ConflictException(ErrorCodes.Table.AlreadyReserved);
            }
        }
    }
}
