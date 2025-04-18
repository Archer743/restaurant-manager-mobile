using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Restaurant_API.Data.Entities
{
	public class User
	{
		[Key]
		[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
		public Guid Id { get; set; }


		// Unique
		[Required]
		[StringLength(40, MinimumLength = 3)]
		public string Username { get; set; }


		[Required]
		[StringLength(50, MinimumLength = 1)]
		public string FirstName { get; set; }


		[Required]
		[StringLength(50, MinimumLength = 1)]
		public string LastName { get; set; }


		[Required]
		public string PasswordHash { get; set; }


		[ForeignKey(nameof(Role))]
		public Guid RoleId { get; set; }

		public Role Role { get; set; }
	}
}
