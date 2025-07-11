using Restaurant_API.Data.Entities;

namespace Restaurant_API.Repositories.Interfaces
{
    public interface ITableRepo
    {
        Task<List<Table>> GetAllRestaurantTablesAsync(Guid restaurantId);
    }
}
