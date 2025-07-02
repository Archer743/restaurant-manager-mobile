import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/back_leading_app_bar.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/buttons/action_button.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_bloc.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/reservation_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/reservation_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/reservation_state.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/forms/reservation_form.dart';

class ReservationCreatePage extends StatefulWidget {
  final DateTime initialDate; // Local time

  const ReservationCreatePage({super.key, required this.initialDate});

  @override
  State<ReservationCreatePage> createState() => _ReservationCreatePageState();
}

class _ReservationCreatePageState extends State<ReservationCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _peopleCountController = TextEditingController();
  final _commentController = TextEditingController();

  late final CalendarBloc? _calendarBloc;
  bool _refreshRequired = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = widget.initialDate.toYYYYMMDDString();
    _timeController.text = TimeOfDay.now().toHHMMSSString();
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
        rawDatesAffected: [DateTime.parse(_dateController.text)],
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

  void _saveNewReservation() {
    if (_formKey.currentState?.validate() ?? false) {
      // Submit form
      context.read<ReservationBloc>().add(
            CreateReservation(
              name: _nameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
              dateString: _dateController.text,
              timeString: _timeController.text,
              peopleCountString: _peopleCountController.text,
              comment: _commentController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackLeadingAppBar(title: 'Нова Резервация'),
      body: BlocConsumer<ReservationBloc, ReservationState>(
        listener: (context, state) {
          if (state is ReservationSaved) {
            setState(() => _refreshRequired = true);
            SnackBarService.showSuccess(
                context, 'Резервацията беше запазена успешно');
            context.pop(); // Go back to prev page
          } else if (state is ReservationError) {
            SnackBarService.showFailure(context, state.failure);

            if (state.failure.requiresReauthentication) {
              context.go(AppRoutes.welcome);
            }
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ReservationForm(
                      formKey: _formKey,
                      displayMode: ReservationFormMode.create,
                      nameController: _nameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      dateController: _dateController,
                      timeController: _timeController,
                      peopleCountController: _peopleCountController,
                      commentController: _commentController,
                    ),
                    ActionButton(
                      label: 'Запази',
                      onPressed: _saveNewReservation,
                      isLoading: state is ReservationLoading,
                    ),
                    SizedBox(height: spacingByHeight(context, 0.035)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
