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
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/forms/controllers/reservation_form_controller.dart';
import '../../domain/entities/reservation_form_mode.dart';
import '../bloc/create/reservation_create_bloc.dart';
import '../bloc/create/reservation_create_event.dart';
import '../bloc/create/reservation_create_state.dart';
import '../widgets/forms/reservation_form.dart';

class ReservationCreatePage extends StatefulWidget {
  final DateTime initialDateLocal;

  const ReservationCreatePage({super.key, required this.initialDateLocal});

  @override
  State<ReservationCreatePage> createState() => _ReservationCreatePageState();
}

class _ReservationCreatePageState extends State<ReservationCreatePage> {
  late final ReservationFormController _formController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _formController = ReservationFormController();
    _formController.date.text = widget.initialDateLocal.toYYYYMMDDString();
    _formController.time.text = TimeOfDay.now().toHHMMSSString();
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackLeadingAppBar(title: 'Нова резервация'),
      body: BlocConsumer<ReservationCreateBloc, ReservationCreateState>(
        listener: _listener,
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ReservationForm(
                      formController: _formController,
                      formKey: _formKey,
                      displayMode: ReservationFormMode.create,
                    ),
                    ActionButton(
                      label: 'Запази',
                      onPressed: _submitForm,
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

  void _submitForm() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final request = _formController.getRequest();
    context.read<ReservationCreateBloc>().add(CreateReservation(request));
  }

  void _listener(BuildContext context, ReservationCreateState state) {
    if (state is ReservationSaved) {
      SnackBarService.showSuccess(
          context, 'Резервацията беше запазена успешно');

      context.pop(); // Go back to previous page
    } else if (state is ReservationError) {
      SnackBarService.showFailure(context, state.failure);

      if (state.failure.requiresReauthentication) {
        context.go(AppRoutes.welcome);
      }
    }
  }
}
