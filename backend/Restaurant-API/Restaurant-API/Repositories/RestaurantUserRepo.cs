using Microsoft.EntityFrameworkCore;
using Restaurant_API.Data;
using Restaurant_API.Repositories.Interfaces;

namespace Restaurant_API.Repositories
{
    public class RestaurantUserRepo : IRestaurantUserRepo
    {
        private readonly AppDbContext context;

        public RestaurantUserRepo(AppDbContext context)
        {
            this.context = context;
        }

        // Default value of Guid is Guid.Empty NOT null !!!
        public async Task<Guid> GetRestaurantIdByUserIdAsync(Guid userId)
        {
            return await context.RestaurantUsers
                                .Where(ru => ru.UserId == userId)
                                .Select(ru => ru.RestaurantId)
                                .FirstOrDefaultAsync();
        }
    }
}
