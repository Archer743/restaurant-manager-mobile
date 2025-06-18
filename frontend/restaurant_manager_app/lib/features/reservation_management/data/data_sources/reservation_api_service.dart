import 'package:dio/dio.dart';
import 'package:restaurant_manager_app/features/reservation_management/data/models/reservation_update_model.dart';
import 'package:restaurant_manager_app/features/reservation_management/data/models/reservation_view_model.dart';
import 'package:retrofit/retrofit.dart';

part 'reservation_api_service.g.dart';

@RestApi()
abstract class ReservationApiService {
  factory ReservationApiService(Dio dio, {String baseUrl}) =
      _ReservationApiService;

  @GET("/{id}")
  Future<HttpResponse<ReservationViewModel>> getReservation(
    @Header('Authorization') String authorization,
    @Path() String id,
  );

  @PATCH("/{id}")
  Future<HttpResponse<ReservationViewModel>> updateReservation(
    @Header('Authorization') String authorization,
    @Path() String id,
    @Body() ReservationUpdateModel body,
  );
}
