using Restaurant_API.Constants;
using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Mappers;
using Restaurant_API.Data.Models.Shift;
using Restaurant_API.Data.Models.Table;
using Restaurant_API.Exceptions;
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

        public async Task<ShiftViewModel> GetTablesAvailabilityForReservationAsync(HttpContext ctx, Guid reservationId)
        {
            // Load reservation and verify ownership
            Reservation reservation = await reservationService.GetReservationIfOwnedAsync(ctx, reservationId, includeDetails: true);

            // Get reservations's shift and ids of all reserved tables in that shift
            var reservationShiftCtx = await GetReservationShiftContextAsync(reservation);

            return await BuildReservationShiftViewAsync(reservation, reservationShiftCtx);
        }
    
        public async Task<ShiftViewModel?> UpdateReservationTablesAsync(HttpContext ctx, Guid reservationId, ReservationTablesUpdate updateModel)
        {
            // Load reservation and verify ownership
            Reservation reservation = await reservationService.GetReservationIfOwnedAsync(ctx, reservationId, includeDetails: true);
            List<Table> reservationTables = reservation.Tables.ToList();

            bool hasAdds = updateModel.TablesToAdd?.Any() ?? false;
            bool hasRemoves = updateModel.TablesToRemove?.Any() ?? false;

            if (!hasAdds && !hasRemoves)
                return null; // Nothing to update

            ReservationShiftContext reservationShiftCtx;

            // Handle removal of tables
            if (hasRemoves)
            {
                var currentIds = reservationTables.Select(t => t.Id).ToHashSet();
                var toRemoveIds = updateModel.TablesToRemove!.ToHashSet();
                var missing = toRemoveIds.Except(currentIds).ToList();

                if (missing.Any())
                {
                    throw new BadRequestException(ErrorCodes.Table.NotPartOfReservation);
                }

                reservationTables.RemoveAll(t => toRemoveIds.Contains(t.Id));
            }

            // Handle adding new tables
            if (hasAdds)
            {
                var toAddIds = updateModel.TablesToAdd!.ToHashSet();

                var tablesToAdd = await tableRepo.GetTablesByIdsAsync(toAddIds);
                var foundIds = tablesToAdd.Select(t => t.Id).ToHashSet();

                var missing = toAddIds.Except(foundIds).ToList();

                if (missing.Any())
                {
                    throw new NotFoundException(ErrorCodes.Table.NotFound);
                }

                // Ensure all tables belong to same restaurant
                bool allSameRestaurant = tablesToAdd.All(t => t.RestaurantId == reservation.RestaurantId);
                if (!allSameRestaurant)
                {
                    throw new ConflictException(ErrorCodes.Table.BelongsToDifferentRestaurant);
                }

                // Ensure no conflicts in shift period - table already assigned to another reservation
                reservationShiftCtx = await GetReservationShiftContextAsync(reservation);

                var conflictIds = toAddIds.Intersect(reservationShiftCtx.ReservedTableIds).ToList();
                if (conflictIds.Any())
                {
                    throw new ConflictException(ErrorCodes.Table.AlreadyReserved);
                }

                reservationTables.AddRange(tablesToAdd);
            }

            // Apply the changes and persist
            reservation.Tables = reservationTables;
            await reservationRepo.UpdateAsync(reservation);

            // Update shift context
            reservationShiftCtx = await GetReservationShiftContextAsync(reservation);

            return await BuildReservationShiftViewAsync(reservation, reservationShiftCtx);
        }

        private async Task<ReservationShiftContext> GetReservationShiftContextAsync(Reservation reservation)
        {
            // 1. Get the restaurant's time zone
            var restaurantTimeZone = restaurantService.GetTimeZoneInfo(reservation.Restaurant);

            // 2. Convert the reservation start time to local time
            var reservationStartLocal = TimeZoneInfo.ConvertTimeFromUtc(reservation.StartTimeUtc, restaurantTimeZone);
            var localTime = TimeOnly.FromDateTime(reservationStartLocal);
            var localDate = DateOnly.FromDateTime(reservationStartLocal);

            // 3. Find the shift that covers this local time
            var shift = await shiftRepo.GetRestaurantShiftAtTimeAsync(reservation.RestaurantId, localTime) ??
                        throw new BadRequestException(ErrorCodes.Reservation.NoShiftFound);

            // 4. Calculate shift start and end in UTC for that date
            var shiftStartUtc = TimeZoneInfo.ConvertTimeToUtc(localDate.ToDateTime(shift.StartTime), restaurantTimeZone);
            var shiftEndUtc = TimeZoneInfo.ConvertTimeToUtc(localDate.ToDateTime(shift.EndTime), restaurantTimeZone);

            // 5. Get all table IDs reserved in this shift
            var reservedTableIds = await reservationRepo.GetReservedTableIdsInPeriodAsync(
                reservation.RestaurantId,
                shiftStartUtc,
                shiftEndUtc);

            return new ReservationShiftContext {
                Shift = shift,
                ReservedTableIds = reservedTableIds,
            };
        }
    
        private async Task<ShiftViewModel> BuildReservationShiftViewAsync(Reservation reservation, ReservationShiftContext reservationShiftCtx)
        {
            // Get all restaurant tables
            var tables = await tableRepo.GetAllRestaurantTablesAsync(reservation.RestaurantId);

            // Get table IDs for this specific reservation
            var currReservationTableIds = reservation.Tables.Select(t => t.Id).ToHashSet();

            // Map each table to a DTO and set its status
            var tablesAvailability = tables.Select(table =>
            {
                var dto = table.ToAvailabilityView();

                if (currReservationTableIds.Contains(table.Id))
                    dto.Status = TableStatus.ReservedByCurrent;
                else if (reservationShiftCtx.ReservedTableIds.Contains(table.Id))
                    dto.Status = TableStatus.OccupiedByOther;
                else
                    dto.Status = TableStatus.Available;

                return dto;
            }).ToList();

            var shiftView = reservationShiftCtx.Shift.ToView();
            shiftView.Tables = tablesAvailability;

            return shiftView;
        }
    }
}
