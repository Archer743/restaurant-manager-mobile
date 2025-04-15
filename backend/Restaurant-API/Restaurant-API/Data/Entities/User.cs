using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Restaurant_API.Data.Entities
{
	public class User
	{
		[Key]
		[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
		public Guid Id { get; set; }

		public string Username { get; set; }

		public string PasswordHash { get; set; }

		[ForeignKey(nameof(Role))]
		public Guid RoleId { get; set; }

		public Role Role { get; set; }
	}
}
