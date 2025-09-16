import 'package:dio/dio.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/data/models/floor_plan_view_model.dart';
import 'package:retrofit/retrofit.dart';

part 'floor_plan_api_service.g.dart';

@RestApi()
abstract class FloorPlanApiService {
  factory FloorPlanApiService(Dio dio, {String baseUrl}) = _FloorPlanApiService;

  @GET("/floor-plan")
  Future<HttpResponse<FloorPlanViewModel>> getRestaurantFloorPlan(
    @Header('Authorization') String authorization,
    @Query('date') String date,
    @Query('shiftId') String? shiftId,
  );
}
