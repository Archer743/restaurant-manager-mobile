import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/constants/error_codes.dart';
import 'package:restaurant_manager_app/core/errors/error_mapper.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/floor_plan_view.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/reservation_preview/reservation_preview_bloc.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/reservation_preview/reservation_preview_event.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/reservation_preview/reservation_preview_state.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/widgets/bottom_sheets/reservation_preview_bottom_sheet.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/widgets/tables/tables_grid.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/shift_view.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan/floor_plan_bloc.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan/floor_plan_event.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan/floor_plan_state.dart';
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
  List<ShiftView> _allShifts = [];
  int? _selectedShiftIndex;
  String? _selectedReservationId;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback is used to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) => _getFloorPlan());
  }

  void _getFloorPlan({bool isRefresh = false}) {
    String? selectedShiftId;

    if (_allShifts.isNotEmpty && _selectedShiftIndex != null && !isRefresh) {
      selectedShiftId = _allShifts[_selectedShiftIndex!].id;
    }

    context
        .read<FloorPlanBloc>()
        .add(GetFloorPlan(date: _selectedDate, shiftId: selectedShiftId));
  }

  void _handleFloorPlanStateChanges(
      BuildContext context, FloorPlanState state) {
    // Store shifts and index only on the initial load
    if (state is FloorPlanLoaded && state.floorPlanView.shifts != null) {
      setState(() {
        _allShifts = state.floorPlanView.shifts!;
        _selectedShiftIndex = state.floorPlanView.selectedShiftIndex;
      });
    } else if (state is FloorPlanError) {
      final failure = state.failure;

      if (failure is ServerFailure) {
        switch (failure.errorCode) {
          case ErrorCodes.restaurantNoShiftsFound:
            setState(() {
              _allShifts.clear();
              _selectedShiftIndex = null;
            });
            return; // Should show screen instead of snack bar
          case ErrorCodes.shiftNotFound:
          case ErrorCodes.shiftBelongsToDifferentRestaurant:
            setState(() {
              _allShifts.clear();
              _selectedShiftIndex = null;
            });
            _getFloorPlan(isRefresh: true);
            break;
        }
      }

      SnackBarService.showFailure(context, failure);

      if (failure.requiresReauthentication) {
        context.go(AppRoutes.welcome);
      }
    }
  }

  Future<void> _handleReservationPreviewState(
      BuildContext context, ReservationPreviewState state) async {
    if (state is ReservationPreviewLoaded) {
      // Wait until the bottom sheet is closed
      await showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (BuildContext context) {
          return ReservationPreviewBottomSheet(
            reservationPreview: state.reservationPreview,
          );
        },
      );

      // Remove table group selection
      setState(() {
        _selectedReservationId = null;
      });
    } else if (state is ReservationPreviewError) {
      // Remove table group selection
      setState(() {
        _selectedReservationId = null;
      });

      SnackBarService.showFailure(context, state.failure);

      if (state.failure.requiresReauthentication) {
        context.go(AppRoutes.welcome);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Схема на масите')),
      body: BlocConsumer<FloorPlanBloc, FloorPlanState>(
        listener: _handleFloorPlanStateChanges,
        builder: (context, state) {
          return BlocListener<ReservationPreviewBloc, ReservationPreviewState>(
            listener: _handleReservationPreviewState,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildFilters(state is FloorPlanLoading),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _getFloorPlan(isRefresh: true);
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 34.0),
                            _buildBodyContent(state),
                            // Ensures the last row of tables is not clipped
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilters(bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: DateFilter(
            isEnabled: !isLoading,
            initialDate: _selectedDate,
            onDateSelected: (date) {
              setState(() => _selectedDate = date);
              _getFloorPlan();
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ShiftFilter(
            isEnabled: _allShifts.isNotEmpty && !isLoading,
            allShifts: _allShifts,
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

  Widget _buildBodyContent(FloorPlanState state) {
    if (state is FloorPlanLoaded) {
      return _buildTableGrid(state.floorPlanView);
    } else if (state is FloorPlanError) {
      final failure = state.failure;

      if (failure is ServerFailure &&
          failure.errorCode == ErrorCodes.restaurantNoShiftsFound) {
        return SizedBox(
          height: spacingByHeight(context, 0.6),
          child: Center(
            child: Text(
              getErrorMessage(failure.errorCode),
              style: defaultTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (state.hasView()) {
        return _buildTableGrid(state.floorPlanView!);
      }
    }

    return SizedBox(
      height: spacingByHeight(context, 0.7),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildTableGrid(FloorPlanView floorPlanView) {
    return TablesGrid(
      tables: floorPlanView.tables,
      selectedReservationId: _selectedReservationId,
      onTableTap: (table) {
        // Clear selection if an unreserved table is tapped
        if (table.reservationId == null) {
          setState(() {
            _selectedReservationId = null;
          });
          return;
        }

        // If the same reservation is tapped again, unselect it
        if (table.reservationId == _selectedReservationId) {
          setState(() {
            _selectedReservationId = null;
          });
          return;
        }

        // If a different reserved table is tapped, select it and show the preview
        setState(() {
          _selectedReservationId = table.reservationId;
        });

        context
            .read<ReservationPreviewBloc>()
            .add(GetReservationPreview(table.reservationId!));
      },
    );
  }
}
