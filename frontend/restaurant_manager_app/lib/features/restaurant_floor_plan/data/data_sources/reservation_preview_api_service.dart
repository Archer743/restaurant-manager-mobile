import 'package:dio/dio.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/data/models/reservation_preview_model.dart';
import 'package:retrofit/retrofit.dart';

part 'reservation_preview_api_service.g.dart';

@RestApi()
abstract class ReservationPreviewApiService {
  factory ReservationPreviewApiService(Dio dio, {String baseUrl}) =
      _ReservationPreviewApiService;

  @GET("/{id}/floor-plan-preview")
  Future<HttpResponse<ReservationPreviewModel>> getReservationPreview(
    @Header('Authorization') String authorization,
    @Path() String id,
  );
}
