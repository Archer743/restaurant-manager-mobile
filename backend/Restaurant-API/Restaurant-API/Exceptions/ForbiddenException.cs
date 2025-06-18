using Restaurant_API.Constants;
using System.Net;

namespace Restaurant_API.Exceptions
{
	public class ForbiddenException : HttpException
	{
		public ForbiddenException() : base(HttpStatusCode.Forbidden, ErrorCodes.Auth.ForbiddenAccess) { }
	}
}
