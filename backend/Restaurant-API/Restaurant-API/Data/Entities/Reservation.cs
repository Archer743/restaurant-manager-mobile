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


        // Required name of the client
        [Required, MaxLength(100)]
        public string Name { get; set; } = string.Empty;


        [Required, EmailAddress]
        public string Email { get; set; } = string.Empty;


        [Required, Phone]
        public string Phone { get; set; } = string.Empty;


        [Required]
        public DateTime StartTimeUtc { get; set; }


        [Required, Range(1, 100)]
        public int PeopleCount { get; set; }


        // Optional comment
        [MaxLength(500)]
        public string? Comment { get; set; }


        public ReservationState State { get; set; }


        // Indicates if this reservation was created directly by a staff member
        public bool IsCreatedByStaff { get; set; } = false;
    }
}
