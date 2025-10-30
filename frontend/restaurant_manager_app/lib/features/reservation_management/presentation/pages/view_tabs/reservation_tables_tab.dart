import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/constants/error_codes.dart';
import 'package:restaurant_manager_app/core/errors/error_mapper.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/app_refresh_indicator.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';
import 'package:restaurant_manager_app/core/domain/entities/table_availability.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_state.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/coordinators/reservation_refresh_coordinator.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/pages/view_tabs/reservation_details_tab.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/dialogs/table_selection_warning_dialog.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/shift_display.dart';

class ReservationTablesTab extends StatefulWidget {
  final String reservationId;
  final ReservationDetailsTabController detailsTabController;
  final ReservationRefreshCoordinator coordinator;
  final Future<void> Function() onRefresh;

  const ReservationTablesTab({
    super.key,
    required this.reservationId,
    required this.detailsTabController,
    required this.coordinator,
    required this.onRefresh,
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
        return Scaffold(
          body: AppRefreshIndicator(
            onRefresh: widget.onRefresh,
            child: _buildContent(context, state),
          ),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, ReservationTablesState state) {
    if (state is ReservationTablesError) {
      final failure = state.failure;

      // Should show screen instead of snack bar
      if (failure is ServerFailure &&
          (failure.errorCode == ErrorCodes.reservationOutsideShift ||
              failure.errorCode ==
                  ErrorCodes.closedReservationTablesUnavailable)) {
        return;
      }

      // Indicates a concurrency conflict - the reservation was closed by another user or process
      // while we had still access to update tables
      if (failure is ServerFailure &&
          failure.errorCode ==
              ErrorCodes.cannotModifyTablesOfClosedReservation) {
        context.read<ReservationTablesBloc>().add(ReservationClosedEvent());
      }

      SnackBarService.showFailure(context, state.failure);

      if (failure.requiresReauthentication) {
        context.go(AppRoutes.welcome);
      }
    } else if (state is ReservationTablesUpdated) {
      widget.coordinator.requireFloorPlanRefresh();
      widget.coordinator.requireReservationPreviewRefresh();

      SnackBarService.showSuccess(context, 'Масите бяха обновени успешно');
    }
  }

  void _onSavePressed(ReservationTablesLoaded state, int peopleCount) {
    void saveTableSelection() {
      context
          .read<ReservationTablesBloc>()
          .add(SaveTableSelection(widget.reservationId));
    }

    final int maxAcceptableCapacity = peopleCount + 5;

    final totalCapacity = state.shiftView.tables.where(
      (table) {
        bool isSelected = state.selectedTableIds.contains(table.id);

        // Reserved tables that aren't removed and new added tables
        return (table.status == TableStatus.reservedByCurrent && !isSelected) ||
            (table.status == TableStatus.available && isSelected);
      },
    ).fold(0, (currCapacity, table) => currCapacity + table.capacity);

    if (totalCapacity < peopleCount || totalCapacity > maxAcceptableCapacity) {
      showTableSelectionWarningDialog(
        context: context,
        onConfirm: saveTableSelection,
        peopleCount: peopleCount,
        totalCapacity: totalCapacity,
        maxAcceptableCapacity: maxAcceptableCapacity,
      );
    } else {
      saveTableSelection();
    }
  }

  Widget _buildContent(BuildContext context, ReservationTablesState state) {
    if (state is ReservationTablesLoaded) {
      return _buildLoadedContent(context, state);
    } else if (state is ReservationTablesClosed) {
      return _buildMessageScreen(ErrorCodes.closedReservationTablesUnavailable);
    } else if (state is ReservationTablesError) {
      final failure = state.failure;

      if (failure is ServerFailure &&
          (failure.errorCode == ErrorCodes.reservationOutsideShift ||
              failure.errorCode ==
                  ErrorCodes.closedReservationTablesUnavailable)) {
        return _buildMessageScreen(failure.errorCode);
      }
    }

    // Always scrollable to allow pull-to-refresh while loading
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: spacingByHeight(context, 0.8),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  /// Build the main content when data is loaded
  Widget _buildLoadedContent(
      BuildContext context, ReservationTablesLoaded state) {
    final shift = state.shiftView;
    final selectedTableIds = state.selectedTableIds;

    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 100, // Leaves space for the save button
              ),
              child: ShiftDisplay(
                shift: shift,
                selectedTableIds: selectedTableIds,
                onTableTap: (table) {
                  if (table.status != TableStatus.reserved) {
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
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBottomSaveButton(),
        ),
      ],
    );
  }

  /// Build the bottom save button with animation
  Widget _buildBottomSaveButton() {
    return SafeArea(
      child: BlocBuilder<ReservationTablesBloc, ReservationTablesState>(
        builder: (context, state) {
          final bool tablesSelected = (state is ReservationTablesLoaded &&
              state.selectedTableIds.isNotEmpty);

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: tablesSelected
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ValueListenableBuilder<int?>(
                        valueListenable:
                            widget.detailsTabController.peopleCountNotifier,
                        builder: (context, peopleCount, _) {
                          return ElevatedButton.icon(
                            onPressed: peopleCount != null
                                ? () => _onSavePressed(state, peopleCount)
                                : null,
                            icon: const Icon(Icons.save),
                            label: const Text('Запази промените'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: actionColor,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  /// Build message screen when reservation is not in a shift or is closed
  Widget _buildMessageScreen(String errorCode) {
    return SafeArea(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          SizedBox(
            height:
                spacingByHeight(context, 0.8), // Enough to center vertically
            child: Center(
              child: Text(
                getErrorMessage(errorCode),
                style: defaultTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
