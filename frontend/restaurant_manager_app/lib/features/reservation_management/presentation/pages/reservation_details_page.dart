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

  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _peopleCountController = TextEditingController();
  final _commentController = TextEditingController();

  void _setControllers() {
    if (_reservation == null) return;
    const dateOnlyConverter = AppDateOnlyConverter();
    _dateController.text = dateOnlyConverter.toJson(_reservation!.date);

    _timeController.text = _reservation!.time;
    _peopleCountController.text = _reservation!.peopleCount.toString();
    _commentController.text = _reservation!.comment ?? '';
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _peopleCountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackLeadingAppBar(
        title: 'Резервация',
        actions: [
          IconButton(
            icon: Icon(_editModeActivated ? Icons.check : Icons.edit),
            tooltip: _editModeActivated ? 'Готово' : 'Редакция',
            onPressed: _reservation != null
                ? () {
                    if (_editModeActivated) {
                      // Submit changes when exiting edit mode
                      context.read<ReservationBloc>().add(
                            UpdateReservation(
                              originalReservation: _reservation!,
                              dateString: _dateController.text,
                              timeString: _timeController.text,
                              peopleCountString: _peopleCountController.text,
                              commentString: _commentController.text,
                            ),
                          );
                    }

                    setState(() {
                      _editModeActivated = !_editModeActivated;
                    });
                  }
                : null,
          ),
        ],
      ),
      body: BlocConsumer<ReservationBloc, ReservationState>(
        listener: (context, state) {
          if (state is ReservationLoaded) {
            setState(() {
              _reservation = state.reservation;
              _setControllers();
            });

            if (state is ReservationUpdated) {
              SnackBarService.showSuccess(
                  context, 'Резервацията беше обновена успешно');

              // Dispatch refresh to CalendarBloc
              context.read<CalendarBloc>().add(
                    GetReservationsForMonth(
                        state.reservation.date), // or _focusedDay
                  );
            }
          } else if (state is ReservationError) {
            SnackBarService.showFailure(context, state.failure);

            if (state.requiresReauthentication) {
              context.go(AppRoutes.welcome);
            }
          }
        },
        builder: (context, state) {
          if (state is ReservationLoaded) {
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

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
