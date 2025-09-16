import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan_bloc.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan_state.dart';

class RestaurantFloorPlanPage extends StatefulWidget {
  const RestaurantFloorPlanPage({super.key});

  @override
  State<RestaurantFloorPlanPage> createState() =>
      _RestaurantFloorPlanPageState();
}

class _RestaurantFloorPlanPageState extends State<RestaurantFloorPlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Схема на масите')),
      // body: BlocConsumer<FloorPlanBloc, FloorPlanState>(
      //   listener: _handleStateChanges,
      //   builder: (context, state) {},
      // ),
    );
  }

  void _handleStateChanges(BuildContext context, FloorPlanState state) {}
}
