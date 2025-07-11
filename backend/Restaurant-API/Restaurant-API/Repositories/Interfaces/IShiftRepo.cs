using Restaurant_API.Data.Entities;

namespace Restaurant_API.Repositories.Interfaces
{
    public interface IShiftRepo
    {
        Task<Shift?> GetRestaurantShiftAtTimeAsync(Guid restaurantId, TimeOnly localTime);
    }
}
