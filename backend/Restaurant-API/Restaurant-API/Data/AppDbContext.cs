using Microsoft.EntityFrameworkCore;
using Restaurant_API.Data.Entities;

namespace Restaurant_API.Data
{
	public class AppDbContext : DbContext
	{
		public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
		
		public DbSet<User> Users { get; set; }

		public DbSet<Role> Roles { get; set; }
	}
}
