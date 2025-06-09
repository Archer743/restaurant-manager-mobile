using Restaurant_API.Data.Entities;

namespace Restaurant_API.Repositories.Interfaces
{
    public interface IReservationRepo
    {
        Task AddAsync(Reservation reservation);
    }
}
