import 'package:dio/dio.dart';
import 'package:restaurant_manager_app/features/user_profile/data/models/user_profile_view_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_profile_api_service.g.dart';

@RestApi()
abstract class UserProfileApiService {
  factory UserProfileApiService(Dio dio, {String baseUrl}) =
      _UserProfileApiService;

  @GET("/current")
  Future<HttpResponse<UserProfileViewModel>> getCurrUserProfile(
    @Header('Authorization') String authorization,
  );
}
