import 'package:dio/dio.dart';
import 'package:restaurant_manager_app/features/auth/data/models/user_login_model.dart';
import 'package:restaurant_manager_app/features/auth/data/models/user_register_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:restaurant_manager_app/core/data/models/auth_model.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST("/login")
  Future<HttpResponse<AuthModel>> login(@Body() UserLoginModel model);

  @POST("/register")
  Future<HttpResponse<AuthModel>> register(@Body() UserRegisterModel model);
}
