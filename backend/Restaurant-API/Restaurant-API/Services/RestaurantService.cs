using Restaurant_API.Constants;
using Restaurant_API.Data.Entities;
using Restaurant_API.Exceptions;
using Restaurant_API.Repositories.Interfaces;
using Restaurant_API.Services.Interfaces;

namespace Restaurant_API.Services
{
    public class RestaurantService : IRestaurantService
    {
        private readonly IRestaurantRepo restaurantRepo;
        private readonly IRestaurantUserRepo restaurantUserRepo;

        public RestaurantService(IRestaurantRepo restaurantRepo, IRestaurantUserRepo restaurantUserRepo)
        {
            this.restaurantRepo = restaurantRepo;
            this.restaurantUserRepo = restaurantUserRepo;
        }

        public async Task<bool> RestaurantExistsAsync(Guid id)
        {
            return await restaurantRepo.GetByIdAsync(id) != null;
        }

        public async Task<Restaurant> GetCurrUserAssociatedRestaurantAsync(HttpContext ctx)
        {
            Guid userId = (Guid)ctx.Items["UserId"]!;

            // Retrieve the restaurant the user is associated with (staff members must be linked to a restaurant)
            Restaurant restaurant = await restaurantUserRepo.GetRestaurantByUserIdAsync(userId) ??
                                    throw new BadRequestException(ErrorCodes.User.NoAssociatedRestaurant);

            return restaurant;
        }

        public TimeZoneInfo GetTimeZoneInfo(Restaurant restaurant)
        {
            return TimeZoneInfo.FindSystemTimeZoneById(restaurant.TimeZoneId);
        }
    }
}
