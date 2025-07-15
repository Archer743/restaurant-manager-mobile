import 'package:dio/dio.dart';
import 'package:restaurant_manager_app/features/reservation_management/data/models/shift_view_model.dart';
import 'package:retrofit/retrofit.dart';

part 'reservation_table_api_service.g.dart';

@RestApi()
abstract class ReservationTableApiService {
  factory ReservationTableApiService(Dio dio, {String baseUrl}) =
      _ReservationTableApiService;

  @GET("/{id}/tables")
  Future<HttpResponse<ShiftViewModel>> getTablesAvailabilityForReservation(
    @Header('Authorization') String authorization,
    @Path() String id,
  );
}
