using Restaurant_API.Exceptions;
using System.Text.Json;

namespace Restaurant_API.Middlewares
{
    public class GlobalExceptionHandlerMiddleware
    {
        private readonly RequestDelegate next;

        public GlobalExceptionHandlerMiddleware(RequestDelegate next)
        {
            this.next = next;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                await next(context);
            }
            catch (HttpException e)
            {
                await WriteErrorResponseAsync(context, e);
            }
            catch (Exception e)
            {
                // TODO: Add Logger
                Console.WriteLine($"!!! Exception: {e.Message} !!!");

                // TODO: Add errorCode
                var error = new InternalServerErrorException();
                await WriteErrorResponseAsync(context, error);
            }
        }

        private async Task WriteErrorResponseAsync(HttpContext context, HttpException e)
        {
			context.Response.ContentType = "application/json";
            context.Response.StatusCode = (int)e.StatusCode;

            var response = JsonSerializer.Serialize(new
            {
                errorCode = e.ErrorCode
            });

            await context.Response.WriteAsync(response);
		}
	}

    public static class GlobalExceptionHandlerMiddlewareExtensions
    {
        public static IApplicationBuilder UseGlobalExceptionHandler(this IApplicationBuilder app)
        {
            return app.UseMiddleware<GlobalExceptionHandlerMiddleware>();
        }
    }
}
