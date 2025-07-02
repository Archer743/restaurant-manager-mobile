import 'package:dio/dio.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/data/models/paged_result_model.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/data/models/pending_reservations_query_params_model.dart';
import 'package:retrofit/retrofit.dart';

part 'pending_reservations_api_service.g.dart';

@RestApi()
abstract class PendingReservationsApiService {
  factory PendingReservationsApiService(Dio dio, {String baseUrl}) =
      _PendingReservationsApiService;

  @GET("/pending")
  Future<HttpResponse<PagedResultModel>> getPendingReservations(
    @Header('Authorization') String authorization,
    @Queries() PendingReservationsQueryParamsModel queryParams,
  );
}
