using Restaurant_API.Data.Entities;

namespace Restaurant_API.Services.Interfaces
{
    public interface IRestaurantService
    {
        Task<bool> RestaurantExistsAsync(Guid id);

        Task<Restaurant> GetCurrUserAssociatedRestaurantAsync(HttpContext ctx);

        TimeZoneInfo GetTimeZoneInfo(Restaurant restaurant);
    }
}
