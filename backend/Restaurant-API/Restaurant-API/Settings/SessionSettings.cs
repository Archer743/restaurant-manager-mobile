using System.ComponentModel.DataAnnotations;

namespace Restaurant_API.Settings
{
	public class SessionSettings
	{
		[Required]
		public int RefreshTokenLength { get; set; }

		[Required]
		public string ServerSecretKey { get; set; }

		[Required]
		public TimeSpan SessionLifetime { get; init; }

		[Required]
		public TimeSpan CleanupInterval { get; init; }
	}
}
