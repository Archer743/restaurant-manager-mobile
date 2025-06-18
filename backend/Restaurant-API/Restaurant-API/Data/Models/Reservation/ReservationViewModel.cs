namespace Restaurant_API.Data.Models.Reservation
{
    public class ReservationViewModel
    {
        public Guid Id { get; set; }

        public string Phone { get; set; } = string.Empty;

        public string Email { get; set; } = string.Empty;

        public DateOnly Date { get; set; }

        public TimeOnly Time { get; set; }

        public int PeopleCount { get; set; }

        public string Name { get; set; } = string.Empty;

        public string? Comment { get; set; }
    }
}
