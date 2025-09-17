import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/tables/tables_grid.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/shift_view.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan_bloc.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan_event.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan_state.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/widgets/filters/date_filter.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/widgets/filters/shift_filter.dart';

class RestaurantFloorPlanPage extends StatefulWidget {
  const RestaurantFloorPlanPage({super.key});

  @override
  State<RestaurantFloorPlanPage> createState() =>
      _RestaurantFloorPlanPageState();
}

class _RestaurantFloorPlanPageState extends State<RestaurantFloorPlanPage> {
  DateTime _selectedDate = DateTime.now(); // local time
  List<ShiftView>? _allShifts;
  int? _selectedShiftIndex;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback is used to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) => _getFloorPlan());
  }

  void _getFloorPlan() {
    String? selectedShiftId;

    if (_allShifts != null && _selectedShiftIndex != null) {
      selectedShiftId = _allShifts![_selectedShiftIndex!].id;
    }

    context
        .read<FloorPlanBloc>()
        .add(GetFloorPlan(date: _selectedDate, shiftId: selectedShiftId));
  }

  void _handleStateChanges(BuildContext context, FloorPlanState state) {
    if (state is FloorPlanLoaded && state.floorPlanView.shifts != null) {
      // Store shifts and index only on the initial load
      _allShifts = state.floorPlanView.shifts;
      _selectedShiftIndex = state.floorPlanView.selectedShiftIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Схема на масите')),
      body: BlocConsumer<FloorPlanBloc, FloorPlanState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          if (state is FloorPlanLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FloorPlanError) {
            return Center(child: Text('Error: ${state.failure}'));
          }
          if (state is FloorPlanLoaded) {
            final floorPlanView = state.floorPlanView;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildFilters(),
                  const SizedBox(height: 24.0),
                  // Space for the tables visualization
                  Expanded(
                    child: SingleChildScrollView(
                      child: TablesGrid(
                        tables: floorPlanView.tables,
                        selectedTableIds: const {}, // This is just a placeholder
                        onTableTap: (_) {}, // This is just a placeholder
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: DateFilter(
            initialDate: _selectedDate,
            onDateSelected: (date) {
              setState(() => _selectedDate = date);
              _getFloorPlan();
            },
          ),
        ),
        const SizedBox(width: 16),
        if (_allShifts != null)
          Expanded(
            child: ShiftFilter(
              allShifts: _allShifts!,
              selectedShiftIndex: _selectedShiftIndex,
              onShiftSelected: (int? newIndex) {
                if (newIndex != null) {
                  setState(() => _selectedShiftIndex = newIndex);
                  _getFloorPlan();
                }
              },
            ),
          ),
      ],
    );
  }
}
