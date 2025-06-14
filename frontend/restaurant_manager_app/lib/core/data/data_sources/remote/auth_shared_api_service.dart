import 'package:dio/dio.dart';
import 'package:restaurant_manager_app/core/data/models/auth_refresh_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:restaurant_manager_app/core/data/models/auth_model.dart';

part 'auth_shared_api_service.g.dart';

@RestApi()
abstract class AuthSharedApiService {
  factory AuthSharedApiService(Dio dio, {String baseUrl}) =
      _AuthSharedApiService;

  @POST("/refresh")
  Future<HttpResponse<AuthModel>> refresh(@Body() AuthRefreshModel model);
}
