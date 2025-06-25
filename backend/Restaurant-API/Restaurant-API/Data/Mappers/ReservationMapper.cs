using Restaurant_API.Data.Entities;
using Restaurant_API.Data.Models.Reservation;

namespace Restaurant_API.Data.Mappers
{
    public static class ReservationMapper
    {
        public static Reservation ToEntity(this ClientReservationCreateModel createModel)
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

        public static Reservation ToEntity(this ReservationCreateModel createModel)
        {
            return new Reservation
            {
                // RestaurantId is set in ReservationService based on the current user
                Phone = createModel.Phone,
                Email = createModel.Email,
                Date = createModel.Date,
                Time = createModel.Time,
                PeopleCount = createModel.PeopleCount,
                Name = createModel.Name,
                Comment = createModel.Comment,
            };
        }

        public static ReservationPreviewModel ToPreview(this Reservation reservation)
        {
            return new ReservationPreviewModel
            {
                Id = reservation.Id,
                Time = reservation.Time,
                PeopleCount = reservation.PeopleCount,
                Name = reservation.Name,
                IsCreatedByStaff = reservation.IsCreatedByStaff,
            };
        }

        public static ReservationViewModel ToView(this Reservation reservation)
        {
            return new ReservationViewModel
            {
                Id = reservation.Id,
                Phone = reservation.Phone,
                Email = reservation.Email,
                Date = reservation.Date,
                Time = reservation.Time,
                PeopleCount = reservation.PeopleCount,
                Name = reservation.Name,
                Comment = reservation.Comment,
                IsCreatedByStaff = reservation.IsCreatedByStaff,
            };
        }
    }
}
