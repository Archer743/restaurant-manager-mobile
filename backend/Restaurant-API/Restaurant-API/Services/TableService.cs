using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Mappers;
using Restaurant_API.Data.Models.Shift;
using Restaurant_API.Data.Models.Table;
using Restaurant_API.Repositories.Interfaces;
using Restaurant_API.Services.Interfaces;

namespace Restaurant_API.Services
{
    public class TableService : ITableService
    {
        private readonly IReservationService reservationService;
        private readonly IRestaurantService restaurantService;
        private readonly IShiftRepo shiftRepo;
        private readonly ITableRepo tableRepo;
        private readonly IReservationRepo reservationRepo;

        public TableService(IReservationService reservationService, IRestaurantService restaurantService, IShiftRepo shiftRepo, ITableRepo tableRepo, IReservationRepo reservationRepo)
        {
            this.reservationService = reservationService;
            this.restaurantService = restaurantService;

            this.shiftRepo = shiftRepo;
            this.tableRepo = tableRepo;
            this.reservationRepo = reservationRepo;
        }

        public async Task<ShiftViewModel?> GetTablesAvailabilityForReservationAsync(HttpContext ctx, Guid reservationId)
        {
            Reservation reservation = await reservationService.GetReservationIfOwnedAsync(ctx, reservationId, includeDetails: true);

            // 1. Get the restaurant's time zone
            var restaurantTimeZone = restaurantService.GetTimeZoneInfo(reservation.Restaurant);

            // 2. Convert the reservation start time to local time
            var reservationStartLocal = TimeZoneInfo.ConvertTimeFromUtc(reservation.StartTimeUtc, restaurantTimeZone);
            var localTime = TimeOnly.FromDateTime(reservationStartLocal);
            var localDate = DateOnly.FromDateTime(reservationStartLocal);

            // 3. Find the shift that covers this local time
            var shift = await shiftRepo.GetRestaurantShiftAtTimeAsync(reservation.RestaurantId, localTime);
            if (shift == null) return null;

            // 4. Calculate shift start and end in UTC for that date
            var shiftStartUtc = TimeZoneInfo.ConvertTimeToUtc(localDate.ToDateTime(shift.StartTime), restaurantTimeZone);
            var shiftEndUtc = TimeZoneInfo.ConvertTimeToUtc(localDate.ToDateTime(shift.EndTime), restaurantTimeZone);

            // 5. Get all table IDs reserved in this shift
            var reservedTableIds = await reservationRepo.GetReservedTableIdsInPeriodAsync(
                reservation.RestaurantId,
                shiftStartUtc,
                shiftEndUtc);

            // 6. Get table IDs for this specific reservation
            var currReservationTableIds = reservation.Tables.Select(t => t.Id).ToHashSet();

            // 7. Get all tables for the restaurant
            var tables = await tableRepo.GetAllRestaurantTablesAsync(reservation.RestaurantId);

            // 8. Map each table to a DTO and set its status
            var tablesAvailability = tables.Select(table =>
            {
                var dto = table.ToAvailabilityView();

                if (currReservationTableIds.Contains(table.Id))
                    dto.Status = TableStatus.ReservedByCurrent;
                else if (reservedTableIds.Contains(table.Id))
                    dto.Status = TableStatus.OccupiedByOther;
                else
                    dto.Status = TableStatus.Available;

                return dto;
            }).ToList();

            var shiftView = shift.ToView();
            shiftView.Tables = tablesAvailability;

            return shiftView;
        }
    }
}
