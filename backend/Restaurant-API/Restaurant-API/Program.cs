using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Restaurant_API.Data;

namespace Restaurant_API
{
	public class Program
	{
		private static void ConfigureServices(WebApplicationBuilder builder)
		{
			builder.Services.AddControllers();  // Support for controllers, model binding, attribute routing, etc.
			builder.Services.AddEndpointsApiExplorer();  // Swagger can find and display all API endpoints
			builder.Services.AddSwaggerGen();  // Swagger UI to test the API in the browser


			// Allows receiving requests from other domains
			builder.Services.AddCors(options =>
			{
				options.AddDefaultPolicy(
					builder =>
					{
						builder.WithOrigins("*")
							   .AllowAnyHeader()
							   .AllowAnyMethod();
					});
			});


			/* builder.Services
			 * .AddSingleton	=> One instance is created and shared across the entire app lifetime.
			 * .AddScoped		=> One instance per HTTP request.
			 * .AddTransient	=> New instance every time it’s requested.
			 */

			// TODO: Remove when Settings are added
			var connectionString =
				builder.Configuration.GetConnectionString("PostgresConnection") ??
				throw new InvalidOperationException("Connection string 'PostgresConnection' not found!");

			builder.Services.AddDbContext<AppDbContext>(c => c.UseNpgsql(connectionString));

			// TODO: Setup Repositories

			// TODO: Setup Services
		}

		// Middleware Setup
		private static void ConfigureApp(WebApplication app)
		{
			// Swagger Setup in Dev Environment
			if (app.Environment.IsDevelopment())
			{
				app.UseSwagger();
				app.UseSwaggerUI();
			}

			app.UseCors();  // Enables CORS
			app.UseHttpsRedirection();  // Redirects all HTTP requests to HTTPS

			// TODO: Add Global Exception Handling
			// app.UseGlobalExceptionHandler();

			// TODO: Add JWT Support
			// app.UseAccessToken();
			// app.UseRefreshToken();

			app.MapControllers();  // Routes requests to controller actions

			// TODO: Enable Database Seeding
			// app.SeedDbAsync().GetAwaiter().GetResult();
		}

		public static void Main(string[] args)
		{
			// Create an app builder
			var builder = WebApplication.CreateBuilder(args);
			ConfigureServices(builder);

			// Create an app based on the builder
			var app = builder.Build();
			ConfigureApp(app);

			app.Run();
		}
	}
}
