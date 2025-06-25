namespace Restaurant_API.Data.Models.Reservation
{
    public class ClientReservationCreateModel : ReservationCreateModel
    {
        public Guid RestaurantId { get; set; }
    }
}
