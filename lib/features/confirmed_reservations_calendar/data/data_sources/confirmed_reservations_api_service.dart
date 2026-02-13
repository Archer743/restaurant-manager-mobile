import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/data/models/reservation_preview_model.dart';

part 'confirmed_reservations_api_service.g.dart';

@RestApi()
abstract class ConfirmedReservationsApiService {
  factory ConfirmedReservationsApiService(Dio dio, {String baseUrl}) =
      _ConfirmedReservationsApiService;

  @GET("/confirmed")
  Future<HttpResponse<List<ReservationPreviewModel>>> getConfirmedReservations(
    @Header('Authorization') String authorization,
    @Query('startUtc') DateTime startUtc,
    @Query('endUtc') DateTime endUtc,
  );
}
