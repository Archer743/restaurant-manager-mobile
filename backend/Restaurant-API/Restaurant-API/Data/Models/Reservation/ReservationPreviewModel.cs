namespace Restaurant_API.Data.Models.Reservation
{
    public class ReservationPreviewModel
    {
        public Guid Id { get; set; }

        public TimeOnly Time { get; set; }

        public int PeopleCount { get; set; }

        public string Name { get; set; }
    }
}
