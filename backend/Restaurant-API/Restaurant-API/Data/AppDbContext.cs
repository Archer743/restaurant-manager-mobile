using Microsoft.EntityFrameworkCore;
using Restaurant_API.Data.Entities;

namespace Restaurant_API.Data
{
	public class AppDbContext : DbContext
	{
		public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
		
		public DbSet<User> Users { get; set; }

		public DbSet<Role> Roles { get; set; }

		public DbSet<Session> Sessions { get; set; }

		public DbSet<Restaurant> Restaurants { get; set; }

		public DbSet<Reservation> Reservations { get; set; }

		protected override void OnModelCreating(ModelBuilder modelBuilder)
		{
			base.OnModelCreating(modelBuilder);

			// Makes User.Username Unique
			modelBuilder.Entity<User>()
						.HasIndex(u => u.Username)
						.IsUnique();

			// Makes Role.NormalizedName Unique
			modelBuilder.Entity<Role>()
						.HasIndex(r => r.NormalizedName)
						.IsUnique();
		}
	}
}
