using Restaurant_API.Data.Entities;

namespace Restaurant_API.Repositories.Interfaces
{
    public interface IReservationRepo
    {
        Task AddAsync(Reservation reservation);

        Task<List<Reservation>> GetConfirmedInPeriodAsync(Guid restaurantId, DateTime periodStartUtc, DateTime periodEndUtc);

        IQueryable<Reservation> GetPendingReservationsBaseQuery(Guid restaurantId);

        Task<Reservation?> GetByIdAsync(Guid id);

        Task UpdateAsync(Reservation reservation);
    }
}
