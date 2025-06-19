using System.ComponentModel.DataAnnotations;

namespace Restaurant_API.Data.Models.Reservation
{
    public class ReservationUpdateModel
    {
        public DateOnly? Date { get; set; }

        public TimeOnly? Time { get; set; }

        [Range(1, 100)]
        public int? PeopleCount { get; set; }

        [MaxLength(500)]
        public string? Comment { get; set; }
    }
}
