import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_bloc.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/details/reservation_details_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/details/reservation_details_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/details/reservation_details_state.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/forms/reservation_form.dart';

/// Acts as a bridge between the ReservationDetailsTab widget and the ReservationViewPage.
/// Holds shared state and callbacks that allow:
/// - Controlling when editing/submitting is allowed (isReservationLoadedNotifier)
/// - Indicating if the reservation was created by staff
/// - Registering and calling a submit callback from the tab
///
/// This decouples the tab’s internal logic from the parent page,
/// so the page can manage buttons and actions consistently.
class ReservationDetailsTabController {
  bool Function()? _submitCallback;

  // Prevents user actions while a request is in progress
  final ValueNotifier<bool> isReservationLoadedNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isCreatedByStaffNotifier = ValueNotifier(false);

  bool submit() {
    if (_submitCallback != null) {
      return _submitCallback!();
    }
    return false;
  }

  void registerSubmitCallback(bool Function() callback) {
    _submitCallback = callback;
  }

  void updateLoadingState({required bool isLoading}) {
    isReservationLoadedNotifier.value = !isLoading;
  }

  void updateCreatedByStaff(bool isCreatedByStaff) {
    isCreatedByStaffNotifier.value = isCreatedByStaff;
  }
}

class ReservationDetailsTab extends StatefulWidget {
  final String reservationId;
  final ReservationDetailsTabController controller;
  final ReservationFormMode displayMode;
  final Future<void> Function() onRefresh;

  const ReservationDetailsTab({
    super.key,
    required this.reservationId,
    required this.controller,
    required this.displayMode,
    required this.onRefresh,
  });

  @override
  State<ReservationDetailsTab> createState() => _ReservationDetailsTabState();
}

class _ReservationDetailsTabState extends State<ReservationDetailsTab>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isCreatedByStaff = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _peopleCountController = TextEditingController();
  final _commentController = TextEditingController();

  // Refresh Calendar Page
  late final CalendarBloc? _calendarBloc;
  bool _refreshRequired = false;
  List<DateTime> rawDatesAffected = [];

  void _setControllers(ReservationView reservation) {
    _nameController.text = reservation.name;
    _emailController.text = reservation.email;
    _phoneController.text = reservation.phone;
    _peopleCountController.text = reservation.peopleCount.toString();
    _commentController.text = reservation.comment ?? '';

    final (localDate, localTime) =
        extractLocalComponentsFromUtc(reservation.startTimeUtc);

    _dateController.text = localDate.toYYYYMMDDString();
    _timeController.text = localTime.toHHMMSSString();
  }

  bool _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return false;

    context.read<ReservationDetailsBloc>().add(
          UpdateReservationDetails(
            name: _nameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            dateString: _dateController.text,
            timeString: _timeController.text,
            peopleCountString: _peopleCountController.text,
            commentString: _commentController.text,
          ),
        );

    return true;
  }

  // By switching tabs unactive tabs are disposed by default.
  // AutomaticKeepAliveClientMixin prevents that
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    widget.controller.registerSubmitCallback(_submitForm);
  }

  // Runs after the widget is inserted into the widget tree and context is still valid.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calendarBloc = context.read<CalendarBloc?>();
  }

  @override
  void dispose() {
    // Update Calendar Page
    if (_refreshRequired && _calendarBloc != null) {
      _calendarBloc.add(RefreshCalendar(rawDatesAffected: rawDatesAffected));
    }

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
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: widget.onRefresh,
            child: _buildContent(context, state),
          ),
        );
      },
    );
  }

  void _handleStateChanges(
      BuildContext context, ReservationDetailsState state) {
    if (state is ReservationDetailsLoading) {
      widget.controller.updateLoadingState(isLoading: true);
    } else if (state is ReservationDetailsUpdated) {
      widget.controller.updateLoadingState(isLoading: false);

      setState(() {
        _refreshRequired = true;
        rawDatesAffected = [
          state.originalStartTimeUtc.toLocal(), // Before update
          state.reservation.startTimeUtc.toLocal(), // After update
        ];
        _setControllers(state.reservation);
      });

      // Reload tables tab
      context
          .read<ReservationTablesBloc>()
          .add(GetTablesAvailability(widget.reservationId));

      SnackBarService.showSuccess(
          context, 'Резервацията беше обновена успешно');
    } else if (state is ReservationDetailsLoaded) {
      widget.controller.updateLoadingState(isLoading: false);
      widget.controller
          .updateCreatedByStaff(state.reservation.isCreatedByStaff);

      setState(() {
        _isCreatedByStaff = state.reservation.isCreatedByStaff;
        _setControllers(state.reservation);
      });
    } else if (state is ReservationDetailsError) {
      setState(() {
        // Reset fields if originalReservation is available
        // It's not available if the state came by result of GetReservationDetails event
        if (state.hasReservation) {
          widget.controller.updateLoadingState(isLoading: false);
          _setControllers(state.originalReservation!);
        }
      });

      SnackBarService.showFailure(context, state.failure);

      if (state.failure.requiresReauthentication) {
        context.go(AppRoutes.welcome);
      }
    }
  }

  Widget _buildContent(BuildContext context, ReservationDetailsState state) {
    if (state is ReservationDetailsLoaded ||
        (state is ReservationDetailsError && state.hasReservation)) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 45, vertical: 16),
                child: ReservationForm(
                  formKey: _formKey,
                  displayMode: widget.displayMode,
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
        },
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
}
