import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/core/constants/error_codes.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/details/reservation_details_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/details/reservation_details_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/details/reservation_details_state.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/coordinators/reservation_refresh_coordinator.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/buttons/reservation_actions_menu.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/forms/reservation_form.dart';

/// Acts as a bridge between the ReservationDetailsTab and the ReservationViewPage
/// by holding shared state
class ReservationDetailsTabController {
  final ValueNotifier<ReservationFormMode> displayModeNotifier =
      ValueNotifier(ReservationFormMode.view);
  final ValueNotifier<bool?> isClosedNotifier = ValueNotifier(null);
  final ValueNotifier<String> tagNotifier = ValueNotifier("");

  void updateDisplayMode(ReservationFormMode newMode) {
    displayModeNotifier.value = newMode;
  }

  void updateIsClosed(bool isClosed) {
    isClosedNotifier.value = isClosed;
  }

  void updateTag(String tag) {
    tagNotifier.value = tag;
  }
}

class ReservationDetailsTab extends StatefulWidget {
  final String reservationId;
  final ReservationDetailsTabController controller;
  final ReservationRefreshCoordinator coordinator;
  final Future<void> Function() onRefresh;

  const ReservationDetailsTab({
    super.key,
    required this.reservationId,
    required this.controller,
    required this.coordinator,
    required this.onRefresh,
  });

  @override
  State<ReservationDetailsTab> createState() => _ReservationDetailsTabState();
}

class _ReservationDetailsTabState extends State<ReservationDetailsTab>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  ReservationFormMode _displayMode = ReservationFormMode.view;
  bool _isCreatedByStaff = false;
  ReservationView? _originalReservation;
  final _hasChangesNotifier = ValueNotifier(false);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _peopleCountController = TextEditingController();
  final _commentController = TextEditingController();

  bool _isReservationDataAvailable(ReservationDetailsState state) {
    return state is ReservationDetailsLoaded ||
        (state is ReservationDetailsError && state.hasReservation);
  }

  void _setControllers(ReservationView reservation) {
    _nameController.text = reservation.name;
    _peopleCountController.text = reservation.peopleCount.toString();
    _emailController.text = reservation.email ?? '';
    _phoneController.text = reservation.phone ?? '';
    _commentController.text = reservation.comment ?? '';

    final (localDate, localTime) =
        extractLocalComponentsFromUtc(reservation.startTimeUtc);

    _dateController.text = localDate.toYYYYMMDDString();
    _timeController.text = localTime.toHHMMSSString();
  }

  void _onFormChanged() {
    if (_originalReservation == null) return;

    final (originalLocalDate, originalLocalTime) =
        extractLocalComponentsFromUtc(_originalReservation!.startTimeUtc);

    final hasChanges = _nameController.text != _originalReservation!.name ||
        _peopleCountController.text !=
            _originalReservation!.peopleCount.toString() ||
        _dateController.text != originalLocalDate.toYYYYMMDDString() ||
        _timeController.text != originalLocalTime.toHHMMSSString() ||
        _emailController.text != (_originalReservation!.email ?? '') ||
        _phoneController.text != (_originalReservation!.phone ?? '') ||
        _commentController.text != (_originalReservation!.comment ?? '');

    _hasChangesNotifier.value = hasChanges;
  }

  void _onSavePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ReservationDetailsBloc>().add(
            UpdateReservationDetails(
              name: _nameController.text,
              dateString: _dateController.text,
              timeString: _timeController.text,
              peopleCountString: _peopleCountController.text,
              email: _emailController.text,
              phone: _phoneController.text,
              commentString: _commentController.text,
            ),
          );
    }
  }

  void _onDiscardPressed() {
    if (_originalReservation != null) {
      _formKey.currentState?.reset(); // Resets the visual errors of the form
      _setControllers(_originalReservation!);
      setState(() {
        _displayMode = ReservationFormMode.view;
        widget.controller.updateDisplayMode(_displayMode);
      });
    }
  }

  // By switching tabs unactive tabs are disposed by default.
  // AutomaticKeepAliveClientMixin prevents that
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
    _dateController.addListener(_onFormChanged);
    _timeController.addListener(_onFormChanged);
    _peopleCountController.addListener(_onFormChanged);
    _commentController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _hasChangesNotifier.dispose();

    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _peopleCountController.dispose();
    _commentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin
    return BlocConsumer<ReservationDetailsBloc, ReservationDetailsState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        final body = Stack(
          children: [
            _buildContent(context, state),
            if (_isReservationDataAvailable(state)) ...[
              if (_displayMode == ReservationFormMode.view)
                _buildActions(context, state),
              if (_displayMode == ReservationFormMode.edit)
                _buildEditActions(context),
            ],
          ],
        );

        // Allow pull-to-refresh only in view mode
        return Scaffold(
          body: _displayMode == ReservationFormMode.view
              ? RefreshIndicator(onRefresh: widget.onRefresh, child: body)
              : body,
        );
      },
    );
  }

  void _handleStateChanges(
      BuildContext context, ReservationDetailsState state) {
    if (state is ReservationClosed) {
      widget.controller.updateIsClosed(state.reservation.isClosed);

      widget.coordinator.requireCalendarRefresh(state.reservation.startTimeUtc);
      widget.coordinator.requireFloorPlanRefresh();
      widget.coordinator.requirePreviewDismiss();

      // Reflect the change in tables tab
      context.read<ReservationTablesBloc>().add(ReservationClosedEvent());

      SnackBarService.showSuccess(
          context, 'Резервацията беше приключена успешно.');
    } else if (state is ReservationActivated) {
      widget.controller.updateIsClosed(state.reservation.isClosed);
      widget.coordinator.requireCalendarRefresh(state.reservation.startTimeUtc);

      // Reload tables tab
      context
          .read<ReservationTablesBloc>()
          .add(GetTablesAvailability(widget.reservationId));

      SnackBarService.showSuccess(
          context, 'Резервацията беше активирана успешно.');
    } else if (state is ReservationDetailsUpdated) {
      setState(() {
        _isCreatedByStaff = state.reservation.isCreatedByStaff;
        _originalReservation = state.reservation;
        _setControllers(state.reservation);
        _hasChangesNotifier.value = false;

        _displayMode = ReservationFormMode.view;
        widget.controller.updateDisplayMode(_displayMode);
      });

      widget.coordinator.requireCalendarRefresh(state.originalStartTimeUtc);
      widget.coordinator.requireCalendarRefresh(state.reservation.startTimeUtc);
      widget.coordinator.requireFloorPlanRefresh();
      widget.coordinator.requireReservationPreviewRefresh();

      // Reload tables tab
      context
          .read<ReservationTablesBloc>()
          .add(GetTablesAvailability(widget.reservationId));

      SnackBarService.showSuccess(
          context, 'Резервацията беше обновена успешно');
    } else if (state is ReservationDetailsLoaded) {
      widget.controller.updateIsClosed(state.reservation.isClosed);
      widget.controller.updateTag(state.reservation.tag);

      setState(() {
        _isCreatedByStaff = state.reservation.isCreatedByStaff;
        _originalReservation = state.reservation;
        _setControllers(state.reservation);
      });
    } else if (state is ReservationRemoved) {
      widget.coordinator.requireCalendarRefresh(state.affectedDateUtc);
      widget.coordinator.requireFloorPlanRefresh();
      widget.coordinator.requirePreviewDismiss();

      SnackBarService.showSuccess(context, 'Резервацията беше изтрита успешно');

      context.pop(); // Go back to prev page
    } else if (state is ReservationDetailsError) {
      // TODO: Handle error codes when reservation is not accessible - update prev page

      setState(() {
        // Reset fields if originalReservation is available
        // It's not available if the state came by result of GetReservationDetails event
        if (state.hasReservation) {
          _originalReservation = state.originalReservation;
          _setControllers(state.originalReservation!);
        }
      });

      final failure = state.failure;

      // Indicates a concurrency conflict - the reservation was closed by another user or process
      // while we had still access to close action. We have to update tables tab
      if (failure is ServerFailure &&
          failure.errorCode == ErrorCodes.reservationAlreadyClosed) {
        context.read<ReservationTablesBloc>().add(ReservationClosedEvent());
      }

      SnackBarService.showFailure(context, state.failure);

      if (state.failure.requiresReauthentication) {
        context.go(AppRoutes.welcome);
      }
    }
  }

  Widget _buildContent(BuildContext context, ReservationDetailsState state) {
    if (_isReservationDataAvailable(state)) {
      final double bottomPadding =
          _displayMode == ReservationFormMode.edit ? 70.0 : 16.0;

      return Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(45, 0, 45, bottomPadding),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ReservationForm(
              formKey: _formKey,
              displayMode: _displayMode,
              isCreatedByStaff: _isCreatedByStaff,
              nameController: _nameController,
              emailController: _emailController,
              phoneController: _phoneController,
              dateController: _dateController,
              timeController: _timeController,
              peopleCountController: _peopleCountController,
              commentController: _commentController,
            ),
          ),
        ),
      );
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

  Widget _buildActions(BuildContext context, ReservationDetailsState state) {
    bool isReservationClosed = false;

    // _isReservationDataAvailable(state) guarantees it's one of these states
    if (state is ReservationDetailsLoaded) {
      isReservationClosed = state.reservation.isClosed;
    } else if (state is ReservationDetailsError && state.hasReservation) {
      isReservationClosed = state.originalReservation!.isClosed;
    }

    return Positioned(
      top: 6,
      right: 6,
      child: ReservationActionsMenu(
        isReservationClosed: isReservationClosed,
        onEdit: () {
          setState(() {
            _displayMode = ReservationFormMode.edit;
            widget.controller.updateDisplayMode(_displayMode);
          });
        },
        onClose: () {
          context
              .read<ReservationDetailsBloc>()
              .add(CloseReservation(widget.reservationId));
        },
        onReopen: () {
          context
              .read<ReservationDetailsBloc>()
              .add(ReopenReservation(widget.reservationId));
        },
        onRemove: () {
          context
              .read<ReservationDetailsBloc>()
              .add(RemoveReservation(widget.reservationId));
        },
      ),
    );
  }

  Widget _buildEditActions(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ValueListenableBuilder<bool>(
        valueListenable: _hasChangesNotifier,
        builder: (context, hasChanges, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: hasChanges ? _onSavePressed : null,
                    child: const Text('Запази'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _onDiscardPressed,
                    child: const Text('Отказ'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
