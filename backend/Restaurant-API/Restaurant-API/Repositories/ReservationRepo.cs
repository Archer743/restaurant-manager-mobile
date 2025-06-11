using Microsoft.EntityFrameworkCore;
using Restaurant_API.Data;
using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Enums;
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

        public async Task<List<Reservation>> GetConfirmedInPeriodAsync(Guid restaurantId, DateOnly start, DateOnly end)
        {
            return await context.Reservations
                                .Where(r => r.RestaurantId == restaurantId &&
                                            r.State == ReservationState.Confirmed &&
                                            r.Date >= start && r.Date <= end)
                                .ToListAsync();
        }
    }
}
