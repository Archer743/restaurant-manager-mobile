namespace Restaurant_API.Data.Models.Reservation
{
    public class ReservationPreviewModel
    {
        public Guid Id { get; set; }

        public string Name { get; set; }

        // Local time of day based on the restaurant time zone
        public TimeOnly Time { get; set; }

        public int PeopleCount { get; set; }

        public bool IsCreatedByStaff { get; set; }
    }
}
