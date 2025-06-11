namespace Restaurant_API.Repositories.Interfaces
{
    public interface IRestaurantUserRepo
    {
        Task<Guid> GetRestaurantIdByUserIdAsync(Guid userId);
    }
}
