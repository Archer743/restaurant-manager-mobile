using Microsoft.Extensions.Options;
using Restaurant_API.Data.Entities;
using Restaurant_API.Repositories.Interfaces;
using Restaurant_API.Services.Interfaces;
using Restaurant_API.Settings;
using Restaurant_API.Exceptions;
using System.Security.Cryptography;
using System.Text;
using Restaurant_API.Constants;
using Restaurant_API.Data.Models.Auth;
using Microsoft.EntityFrameworkCore;

namespace Restaurant_API.Services
{
    public class SessionService : ISessionService
	{
		private readonly SessionSettings sessionSettings;
		private readonly IAuthTokenService authTokenService;
		private readonly ISessionRepo sessionRepo;

		public SessionService(IOptions<SessionSettings> settings, IAuthTokenService authTokenService, ISessionRepo sessionRepo)
		{
			sessionSettings = settings.Value;
			this.authTokenService = authTokenService;
			this.sessionRepo = sessionRepo;
		}

		public async Task<UserAuthModel> CreateNewSessionAsync(Guid userId)
		{
			const int MaxHashRetries = 3;

            // Generate new access and refresh tokens
            Guid sessionId = Guid.NewGuid();
            UserAuthModel tokens = authTokenService.GenerateAuthTokens(userId, sessionId);

			string hashedToken = GetHashedRefreshToken(tokens.RefreshToken);

            bool isHashUnique = false;

			// Ensure that the refresh token's hash is unique
            for (int attempt = 0; attempt < MaxHashRetries; attempt++)
			{
				if (!await sessionRepo.HashExistsAsync(hashedToken))
				{
					isHashUnique = true; break;
				}
				else if (attempt == MaxHashRetries - 1)
				{
					break;
				}

                tokens.RefreshToken = authTokenService.GenerateRefreshToken();
                hashedToken = GetHashedRefreshToken(tokens.RefreshToken);
            }

			if (!isHashUnique)
			{
				throw new ServiceUnavailableException(ErrorCodes.Session.CreationFailed);
            }

            var session = new Session
            {
                Id = sessionId,
                UserId = userId,
                RefreshTokenHash = hashedToken,
                CreatedAt = DateTime.UtcNow,
                ExpiresAt = DateTime.UtcNow.Add(sessionSettings.SessionLifetime),
                IsRevoked = false
            };

			try
			{
                // Save new session
                await sessionRepo.AddAsync(session);
                return tokens;
            }
            catch (DbUpdateException)
            {
                // If there is a Race Condition
                throw new ServiceUnavailableException(ErrorCodes.Session.CreationFailed);
            }
        }

		public async Task<UserAuthModel> RefreshSessionAsync(string refreshToken)
		{
			string hashedToken = GetHashedRefreshToken(refreshToken);
			Session? session = await sessionRepo.GetByHashedTokenAsync(hashedToken);

			// Session must be active - exists, isn't expired and isn't revoked
			if (session == null || session.ExpiresAt < DateTime.UtcNow || session.IsRevoked)
			{
				throw new UnauthorizedException(ErrorCodes.Session.InvalidSession);
			}

			// Generate new access and refresh tokens
			UserAuthModel tokens = authTokenService.GenerateAuthTokens(session.UserId, session.Id);

			// Update session's refresh token & extend the session
			session.RefreshTokenHash = GetHashedRefreshToken(tokens.RefreshToken);
			session.ExpiresAt = DateTime.UtcNow.Add(sessionSettings.SessionLifetime);
			await sessionRepo.UpdateAsync(session);

			return tokens;
		}

		public async Task EndSessionAsync(string refreshToken)
		{
			string hashedToken = GetHashedRefreshToken(refreshToken);
			Session? session = await sessionRepo.GetByHashedTokenAsync(hashedToken);

			// Session must be active - exists, isn't expired and isn't revoked
			if (session == null || session.ExpiresAt < DateTime.UtcNow || session.IsRevoked)
			{
				throw new UnauthorizedException(ErrorCodes.Session.InvalidSession);
			}

			// End session
			session.IsRevoked = true;
			await sessionRepo.UpdateAsync(session);
		}

		public async Task RemoveOldInactiveSessionsAsync()
		{
			var oldSessions = await sessionRepo.GetOldInactiveSessionsAsync(sessionSettings.RetentionDays);
			await sessionRepo.RemoveRangeAsync(oldSessions);
		}

		private string GetHashedRefreshToken(string refreshToken)
		{
			using var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(sessionSettings.ServerSecretKey));
			byte[] hashBytes = hmac.ComputeHash(Encoding.UTF8.GetBytes(refreshToken));
			return Convert.ToBase64String(hashBytes);
		}
	}
}
