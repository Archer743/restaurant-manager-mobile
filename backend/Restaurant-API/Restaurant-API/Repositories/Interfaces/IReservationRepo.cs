using Restaurant_API.Data.Entities;

namespace Restaurant_API.Repositories.Interfaces
{
    public interface IReservationRepo
    {
        Task AddAsync(Reservation reservation);

        IQueryable<Reservation> GetPendingReservationsBaseQuery(Guid restaurantId);

        Task<List<Reservation>> GetConfirmedInPeriodAsync(Guid restaurantId, DateTime periodStartUtc, DateTime periodEndUtc);

        Task<HashSet<Guid>> GetReservedTableIdsInPeriodAsync(Guid restaurantId, DateTime periodStartUtc, DateTime periodEndUtc);

        Task<Reservation?> GetByIdAsync(Guid id);

        Task<Reservation?> GetByIdWithRestaurantAsync(Guid id);

        Task<Reservation?> GetByIdWithDetailsAsync(Guid id);

        Task<Reservation?> GetByTagAsync(Guid restaurantId, string tag);

        Task UpdateAsync(Reservation reservation);

        Task RemoveAsync(Reservation reservation);
    }
}
