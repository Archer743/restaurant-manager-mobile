using System.Net;

namespace Restaurant_API.Exceptions
{
	public class ForbiddenException : HttpException
	{
		public ForbiddenException(string errorCode) : base(HttpStatusCode.Forbidden, errorCode) { }
	}
}
