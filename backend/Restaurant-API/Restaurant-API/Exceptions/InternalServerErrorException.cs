using System.Net;

namespace Restaurant_API.Exceptions
{
    public class InternalServerErrorException : HttpException
    {
        public InternalServerErrorException(string? errorCode = null) : base(HttpStatusCode.InternalServerError, errorCode) { }
    }
}
