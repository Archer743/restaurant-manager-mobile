namespace Restaurant_API.Data.Models.Reservation
{
    public class ReservationPreview
    {
        public Guid Id { get; set; }

        public DateOnly Date { get; set; }

        public TimeOnly Time { get; set; }

        public int PeopleCount { get; set; }

        public string Name { get; set; }
    }
}
