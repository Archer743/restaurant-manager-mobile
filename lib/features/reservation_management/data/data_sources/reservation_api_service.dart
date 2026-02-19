import 'package:dio/dio.dart';
import '../models/reservation_create_model.dart';
import '../models/reservation_update_model.dart';
import '../models/reservation_view_model.dart';
import 'package:retrofit/retrofit.dart';

part 'reservation_api_service.g.dart';

@RestApi()
abstract class ReservationApiService {
  factory ReservationApiService(Dio dio, {String baseUrl}) =
      _ReservationApiService;

  @POST("/confirmed")
  Future<HttpResponse<void>> createReservation(
    @Header('Authorization') String authorization,
    @Body() ReservationCreateModel body,
  );

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

  @DELETE("/{id}")
  Future<HttpResponse<void>> removeReservation(
    @Header('Authorization') String authorization,
    @Path() String id,
  );

  @POST("/{id}/close")
  Future<HttpResponse<void>> closeReservation(
    @Header('Authorization') String authorization,
    @Path() String id,
  );

  @POST("/{id}/reopen")
  Future<HttpResponse<void>> reopenReservation(
    @Header('Authorization') String authorization,
    @Path() String id,
  );
}
