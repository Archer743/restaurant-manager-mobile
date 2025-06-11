using Restaurant_API.Data.Enums;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Restaurant_API.Data.Entities
{
    public class Reservation
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Guid Id { get; set; }


        [ForeignKey(nameof(Restaurant))]
        public Guid RestaurantId { get; set; }

        public Restaurant Restaurant { get; set; }


        [Required, Phone]
        public string Phone { get; set; } = string.Empty;


        [Required, EmailAddress]
        public string Email { get; set; } = string.Empty;


        [Required]
        public DateOnly Date { get; set; }


        [Required]
        public TimeOnly Time { get; set; }


        [Required, Range(1, 100)]
        public int PeopleCount { get; set; }


        // Required name of the client
        [Required, MaxLength(100)]
        public string Name { get; set; } = string.Empty;


        // Optional comment
        [MaxLength(500)]
        public string? Comment { get; set; }


        // The reservation is initially in Pending status and then an employee must confirm or reject it
        public ReservationState State { get; set; }
    }
}
