import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/core/data/converters/app_dateonly_converter.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/back_leading_app_bar.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_bloc.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/reservation_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/reservation_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/reservation_state.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/forms/reservation_edit_form.dart';

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
  bool _editModeActivated = false;

  // Prevents user actions while a request is in progress
  bool _isLoading = false;

  // Editable fields' controllers
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
              SnackBarService.showSuccess(
                  context, 'Резервацията беше обновена успешно');

              if (mounted) {
                setState(() {
                  _refreshRequired = true;
                  _originalDate = state.originalDate;
                  _updatedDate = state.reservation.date;
                });
              }
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
                  child: ReservationEditForm(
                    formKey: _formKey,
                    reservation: _reservation!,
                    editModeActivated: _editModeActivated,
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
    return BackLeadingAppBar(
      title: 'Резервация',
      actions: [
        IconButton(
          icon: Icon(_editModeActivated ? Icons.check : Icons.edit),
          tooltip: _editModeActivated ? 'Готово' : 'Редакция',
          onPressed: _reservation != null && !_isLoading
              ? () {
                  if (_editModeActivated) {
                    final isValid = _formKey.currentState?.validate() ?? false;

                    if (isValid) {
                      // Submit changes
                      context.read<ReservationBloc>().add(
                            UpdateReservation(
                              originalReservation: _reservation!,
                              dateString: _dateController.text,
                              timeString: _timeController.text,
                              peopleCountString: _peopleCountController.text,
                              commentString: _commentController.text,
                            ),
                          );

                      // Exit edit mode only if valid
                      setState(() => _editModeActivated = false);
                    }
                  } else {
                    // Enter edit mode
                    setState(() => _editModeActivated = true);
                  }
                }
              : null,
        ),
      ],
    );
  }
}
