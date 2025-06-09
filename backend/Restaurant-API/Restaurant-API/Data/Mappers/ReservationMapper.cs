using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Models.Reservation;

namespace Restaurant_API.Data.Mappers
{
    public static class ReservationMapper
    {
        public static Reservation ToEntity(this ReservationCreateModel createModel)
        {
            return new Reservation
            {
                RestaurantId = createModel.RestaurantId,
                Phone = createModel.Phone,
                Email = createModel.Email,
                Date = createModel.Date,
                Time = createModel.Time,
                PeopleCount = createModel.PeopleCount,
                Name = createModel.Name,
                Comment = createModel.Comment,
            };
        }
    }
}
