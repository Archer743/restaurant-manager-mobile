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

        public async Task<ShiftContext?> GetShiftContextAsync(Restaurant restaurant, DateTime dateTimeUtc)
        {
            var restaurantTimeZone = restaurantService.GetTimeZoneInfo(restaurant);
            var (localDate, localTime) = ConvertToLocalDateTimeParts(restaurantTimeZone, dateTimeUtc);

            var shift = await shiftRepo.GetRestaurantShiftAtTimeAsync(restaurant.Id, localTime);
            if (shift == null) return null;

            // Calculate shift start and end in UTC for that date
            var shiftStartUtc = TimeZoneInfo.ConvertTimeToUtc(localDate.ToDateTime(shift.StartTime), restaurantTimeZone);
            var shiftEndUtc = TimeZoneInfo.ConvertTimeToUtc(localDate.ToDateTime(shift.EndTime), restaurantTimeZone);

            // Get all table IDs reserved in this shift
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

        public async Task<ShiftContext> GetReservationShiftContextAsync(Reservation reservation)
        {
            var ctx = await GetShiftContextAsync(reservation.Restaurant, reservation.StartTimeUtc);

            if (ctx == null)
            {
                throw new NotFoundException(ErrorCodes.Reservation.OutsideShift);
            }

            return ctx;
        }

        public async Task<bool> HasShiftAtTimeAsync(Restaurant restaurant, DateTime dateTimeUtc)
        {
            return await GetShiftAtTimeAsync(restaurant, dateTimeUtc) != null;
        }

        public async Task ValidateReservationShiftChangeAsync(Reservation reservation, DateTime newStartTimeUtc)
        {
            Shift? currShift = await GetShiftAtTimeAsync(reservation.Restaurant, reservation.StartTimeUtc);
            ShiftContext? newShiftCtx = await GetShiftContextAsync(reservation.Restaurant, newStartTimeUtc);

            if (newShiftCtx == null)
            {
                throw new BadRequestException(ErrorCodes.Reservation.StartTimeOutsideShift);
            }

            // No need to check conflicts if it's the same shift
            if (currShift != null && currShift.Id == newShiftCtx.Shift.Id && reservation.StartTimeUtc.Date == newStartTimeUtc.Date) return;

            var currTableIds = reservation.Tables.Select(t => t.Id).ToHashSet();
            var conflicts = currTableIds.Intersect(newShiftCtx.ReservedTableIds).ToList();

            if (conflicts.Any())
            {
                throw new ConflictException(ErrorCodes.Table.ReservedInNewShift);
            }
        }
    
        private async Task<Shift?> GetShiftAtTimeAsync(Restaurant restaurant, DateTime dateTimeUtc)
        {
            var (_, localTime) = ConvertToLocalDateTimeParts(restaurant, dateTimeUtc);
            return await shiftRepo.GetRestaurantShiftAtTimeAsync(restaurant.Id, localTime);
        }

        private (DateOnly localDate, TimeOnly localTime) ConvertToLocalDateTimeParts(Restaurant restaurant, DateTime dateTimeUtc)
        {
            var timeZone = restaurantService.GetTimeZoneInfo(restaurant);
            return ConvertToLocalDateTimeParts(timeZone, dateTimeUtc);
        }

        private (DateOnly localDate, TimeOnly localTime) ConvertToLocalDateTimeParts(TimeZoneInfo timeZone, DateTime dateTimeUtc)
        {
            var dateTimeLocal = TimeZoneInfo.ConvertTimeFromUtc(dateTimeUtc, timeZone);
            return (DateOnly.FromDateTime(dateTimeLocal), TimeOnly.FromDateTime(dateTimeLocal));
        }
    }
}
