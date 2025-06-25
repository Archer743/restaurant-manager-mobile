import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/data/converters/app_dateonly_converter.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/back_leading_app_bar.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_bloc.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/reservation_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/reservation_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/reservation_state.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/forms/reservation_form.dart';

class ReservationDetailsPage extends StatefulWidget {
  final String reservationId;

  const ReservationDetailsPage({
    super.key,
    required this.reservationId,
  });

  @override
  State<ReservationDetailsPage> createState() => RreservationDetailsPageState();
}

class RreservationDetailsPageState extends State<ReservationDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  ReservationView? _reservation;
  ReservationFormMode _displayMode = ReservationFormMode.view;

  // Prevents user actions while a request is in progress
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _peopleCountController = TextEditingController();
  final _commentController = TextEditingController();

  // Refresh Previous Page
  late final CalendarBloc? _calendarBloc;
  bool _refreshRequired = false;
  DateTime? _originalDate;
  DateTime? _updatedDate;

  void _setControllers() {
    if (_reservation == null) return;
    const dateOnlyConverter = AppDateOnlyConverter();

    _nameController.text = _reservation!.name;
    _emailController.text = _reservation!.email;
    _phoneController.text = _reservation!.phone;
    _dateController.text = dateOnlyConverter.toJson(_reservation!.date);
    _timeController.text = _reservation!.time;
    _peopleCountController.text = _reservation!.peopleCount.toString();
    _commentController.text = _reservation!.comment ?? '';
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
      _calendarBloc.add(RefreshCalendar(
        rawDatesAffected: [_originalDate!, _updatedDate!],
      ));
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
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocConsumer<ReservationBloc, ReservationState>(
        listener: (context, state) {
          if (state is ReservationLoading) {
            setState(() => _isLoading = true);
          } else if (state is ReservationLoaded) {
            setState(() {
              _reservation = state.reservation;
              _isLoading = false;
              _setControllers();
            });

            if (state is ReservationUpdated) {
              setState(() {
                _refreshRequired = true;
                _originalDate = state.originalDate;
                _updatedDate = state.reservation.date;
              });

              SnackBarService.showSuccess(
                  context, 'Резервацията беше обновена успешно');
            }
          } else if (state is ReservationError) {
            // Reset fields with reservation's data
            setState(() {
              _isLoading = false;
              _setControllers();
            });

            SnackBarService.showFailure(context, state.failure);

            if (state.requiresReauthentication) {
              context.go(AppRoutes.welcome);
            }
          }
        },
        builder: (context, state) {
          if (state is ReservationLoading || _reservation == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: SingleChildScrollView(
                  child: ReservationForm(
                    formKey: _formKey,
                    displayMode: _displayMode,
                    isCreatedByStaff: _reservation!.isCreatedByStaff,
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
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    bool editModeActivated = _displayMode == ReservationFormMode.edit;

    return BackLeadingAppBar(
      title: 'Резервация',
      actions: [
        if (_reservation != null && _reservation!.isCreatedByStaff)
          Tooltip(
            message: 'Създадена от служител',
            child: Icon(Icons.verified_user, color: Colors.grey[400]),
          ),
        IconButton(
          icon: Icon(editModeActivated ? Icons.check : Icons.edit),
          tooltip: editModeActivated ? 'Готово' : 'Редакция',
          onPressed: _reservation != null && !_isLoading
              ? () {
                  final isValid = _formKey.currentState?.validate() ?? false;

                  if (editModeActivated && isValid) {
                    // Submit changes
                    context.read<ReservationBloc>().add(
                          UpdateReservation(
                            originalReservation: _reservation!,
                            name: _nameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            dateString: _dateController.text,
                            timeString: _timeController.text,
                            peopleCountString: _peopleCountController.text,
                            commentString: _commentController.text,
                          ),
                        );

                    // Exit edit mode only if valid
                    setState(() => _displayMode = ReservationFormMode.view);
                  } else {
                    // Enter edit mode
                    setState(() => _displayMode = ReservationFormMode.edit);
                  }
                }
              : null,
        ),
      ],
    );
  }
}
