using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Models.Reservation;
using static System.Runtime.InteropServices.JavaScript.JSType;
using System.Xml.Linq;

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

        public static ReservationPreview ToPreview(this Reservation reservation)
        {
            return new ReservationPreview
            {
                Id = reservation.Id,
                Date = reservation.Date,
                Time = reservation.Time,
                PeopleCount = reservation.PeopleCount,
                Name = reservation.Name,
            };
        }
    }
}
