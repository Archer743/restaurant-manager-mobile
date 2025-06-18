namespace Restaurant_API.Data.Models.Reservation
{
    public class ReservationUpdateModel
    {
        public DateOnly? Date { get; set; }

        public TimeOnly? Time { get; set; }

        public int? PeopleCount { get; set; }

        public string? Comment { get; set; }
    }
}
