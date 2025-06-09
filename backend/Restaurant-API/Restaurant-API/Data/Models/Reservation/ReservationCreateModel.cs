using System.ComponentModel.DataAnnotations;

namespace Restaurant_API.Data.Models.Reservation
{
    public class ReservationCreateModel
    {
        public Guid RestaurantId { get; set; }

        [Phone]
        public string Phone { get; set; }

        [EmailAddress]
        public string Email { get; set; }

        public DateOnly Date { get; set; }

        public TimeOnly Time { get; set; }

        [Range(1, 100)]
        public int PeopleCount { get; set; }

        // Required name of the client
        [MaxLength(100)]
        public string Name { get; set; }

        // Optional comment
        [MaxLength(500)]
        public string? Comment { get; set; }
    }
}
