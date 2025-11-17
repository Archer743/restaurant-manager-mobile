import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'logout_api_service.g.dart';

@RestApi()
abstract class LogoutApiService {
  factory LogoutApiService(Dio dio, {String baseUrl}) = _LogoutApiService;

  @POST("/logout")
  Future<HttpResponse<void>> logout(
    @Header('Authorization') String authorization,
  );
}
