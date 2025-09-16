import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/tables/tables_grid.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/shift_view.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan_bloc.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan_event.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan_state.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/widgets/filters/date_filter.dart';

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
            child: DropdownButtonFormField<int>(
              // Aladin's lamp. Allows long text to be displayed without overflowing
              isExpanded: true,
              dropdownColor: primaryColor,
              value: _selectedShiftIndex,
              items: _allShifts!.asMap().entries.map((entry) {
                final index = entry.key;
                final shift = entry.value;
                return DropdownMenuItem<int>(
                  value: index,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shift.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${shift.startTime.toHHMMString()} - ${shift.endTime.toHHMMString()}',
                        style: TextStyle(
                            fontSize: 13, color: hintTextColor.toColor()),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (int? newIndex) {
                if (newIndex != null) {
                  setState(() => _selectedShiftIndex = newIndex);
                  _getFloorPlan();
                }
              },
              selectedItemBuilder: (BuildContext context) {
                return _allShifts!.map((shift) {
                  return Text(
                    shift.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  );
                }).toList();
              },
            ),
          ),
      ],
    );
  }
}
