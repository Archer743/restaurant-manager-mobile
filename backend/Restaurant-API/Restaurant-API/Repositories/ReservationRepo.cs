using Microsoft.EntityFrameworkCore;
using Restaurant_API.Data;
using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Entities.Enums;
using Restaurant_API.Repositories.Interfaces;

namespace Restaurant_API.Repositories
{
    public class ReservationRepo : IReservationRepo
    {
        private readonly AppDbContext context;

        public ReservationRepo(AppDbContext context)
        {
            this.context = context;
        }

        public async Task AddAsync(Reservation reservation)
        {
            context.Reservations.Add(reservation);
            await context.SaveChangesAsync();
        }

        public IQueryable<Reservation> GetPendingReservationsBaseQuery(Guid restaurantId)
        {
            return context.Reservations
                          .Where(r => r.RestaurantId == restaurantId &&
                                      r.State == ReservationState.Pending);
        }

        public async Task<List<Reservation>> GetConfirmedInPeriodAsync(Guid restaurantId, DateTime periodStartUtc, DateTime periodEndUtc)
        {
            return await context.Reservations
                                .Where(r => r.RestaurantId == restaurantId &&
                                            r.State == ReservationState.Confirmed &&
                                            r.StartTimeUtc >= periodStartUtc && r.StartTimeUtc < periodEndUtc)
                                .ToListAsync();
        }

        public async Task<HashSet<Guid>> GetReservedTableIdsInPeriodAsync(Guid restaurantId, DateTime periodStartUtc, DateTime periodEndUtc)
        {
            return await context.Reservations
                                .Include(r => r.Tables)
                                .Where(r => r.RestaurantId == restaurantId &&
                                            r.State == ReservationState.Confirmed &&
                                            r.StartTimeUtc >= periodStartUtc && r.StartTimeUtc < periodEndUtc)
                                .SelectMany(r => r.Tables.Select(t => t.Id))
                                .ToHashSetAsync();
        }

        public async Task<Reservation?> GetByIdAsync(Guid id)
        {
            return await context.Reservations
                                .FirstOrDefaultAsync(r => r.Id == id);
        }

        public async Task<Reservation?> GetByIdWithDetailsAsync(Guid id)
        {
            return await context.Reservations
                                .Include(r => r.Restaurant)
                                .Include(r => r.Tables)
                                .FirstOrDefaultAsync(r => r.Id == id);
        }

        public async Task UpdateAsync(Reservation reservation)
        {
            context.Reservations.Update(reservation);
            await context.SaveChangesAsync();
        }
    }
}
