using Restaurant_API.Attributes;
using System.ComponentModel.DataAnnotations;

namespace Restaurant_API.Data.Models.Reservation
{
    public class ReservationCreateModel
    {
        [Phone]
        public string Phone { get; set; }

        [EmailAddress]
        public string Email { get; set; }

        [MustBeUtc]
        public DateTime StartTimeUtc { get; set; }

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
