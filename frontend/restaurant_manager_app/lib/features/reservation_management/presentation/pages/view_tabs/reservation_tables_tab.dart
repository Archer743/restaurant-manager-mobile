import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/constants/error_codes.dart';
import 'package:restaurant_manager_app/core/errors/error_mapper.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/shift_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/table_availability.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_state.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/tables/tables_grid.dart';

class ReservationTablesTab extends StatefulWidget {
  final String reservationId;

  const ReservationTablesTab({
    super.key,
    required this.reservationId,
  });

  @override
  State<ReservationTablesTab> createState() => _ReservationTablesTabState();
}

class _ReservationTablesTabState extends State<ReservationTablesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<ReservationTablesBloc, ReservationTablesState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        if (state is ReservationTablesLoaded) {
          return _buildLoadedContent(context, state);
        } else if (state is ReservationTablesError) {
          final failure = state.failure;

          // Should show screen instead of snack bar
          if (failure is ServerFailure &&
              failure.errorCode == ErrorCodes.reservationNoShiftFound) {
            return _buildEmptyContent(failure.errorCode);
          }
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, ReservationTablesState state) {
    if (state is ReservationTablesError) {
      final failure = state.failure;

      // Should show screen instead of snack bar
      if (failure is ServerFailure &&
          failure.errorCode == ErrorCodes.reservationNoShiftFound) {
        return;
      }

      SnackBarService.showFailure(context, state.failure);

      if (failure.requiresReauthentication) {
        context.go(AppRoutes.welcome);
      }
    } else if (state is ReservationTablesUpdated) {
      SnackBarService.showSuccess(context, 'Масите бяха обновени успешно');
    }
  }

  /// Build the main content when data is loaded
  Widget _buildLoadedContent(
      BuildContext context, ReservationTablesLoaded state) {
    final shift = state.shiftView;
    final selectedTableIds = state.selectedTableIds;

    return Scaffold(
      body: Stack(
        children: [
          _buildScrollableContent(shift, selectedTableIds),
          _buildBottomSaveButton(),
        ],
      ),
    );
  }

  /// Build the scrollable shift info and tables grid
  Widget _buildScrollableContent(
      ShiftView shift, Set<String> selectedTableIds) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 30,
            bottom: 100, // Leaves space for the save button
          ),
          child: Column(
            children: [
              _buildShiftInfoBlock(context, shift),
              const SizedBox(height: 24.0),
              TablesGrid(
                tables: shift.tables,
                selectedTableIds: selectedTableIds,
                onTableTap: (table) {
                  if (table.status != TableStatus.occupiedByOther) {
                    context
                        .read<ReservationTablesBloc>()
                        .add(ToggleTableSelection(table.id));
                  } else {
                    SnackBarService.showFailureMessage(
                        context, 'Тази маса е заета от друга резервация.',
                        duration: const Duration(seconds: 2));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the bottom save button with animation
  Widget _buildBottomSaveButton() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: BlocBuilder<ReservationTablesBloc, ReservationTablesState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: (state is ReservationTablesLoaded &&
                      state.selectedTableIds.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<ReservationTablesBloc>()
                                .add(SaveTablesSelection(widget.reservationId));
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Запази промените'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: actionColor,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  /// Display shift information (title and time range)
  Widget _buildShiftInfoBlock(BuildContext context, ShiftView shift) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          shift.name,
          style: titleTextStyle,
        ),
        const SizedBox(width: 10.0),
        Text(
          '${shift.startTime.toHHMMString()} - ${shift.endTime.toHHMMString()}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: hintTextColor.toColor(),
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  /// Build empty content screen when reservation is not in a shift
  Widget _buildEmptyContent(String errorCode) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              getErrorMessage(errorCode),
              style: defaultTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
