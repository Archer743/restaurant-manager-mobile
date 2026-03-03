import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/core/constants/error_codes.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/app_refresh_indicator.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import '../../../domain/entities/reservation_view.dart';
import '../../../domain/entities/reservation_form_mode.dart';
import '../../bloc/view/reservation_view_event.dart';
import '../../widgets/buttons/reservation_actions_menu.dart';
import '../../widgets/forms/reservation_form.dart';
import '../../widgets/forms/controllers/reservation_form_controller.dart';
import '../../bloc/view/reservation_view_bloc.dart';
import '../../bloc/view/reservation_view_state.dart';
import '../../bloc/tables/reservation_tables_bloc.dart';
import '../../bloc/tables/reservation_tables_event.dart';

class ReservationDetailsTab extends StatefulWidget {
  final String reservationId;
  final Future<void> Function() onRefresh;

  const ReservationDetailsTab({
    super.key,
    required this.reservationId,
    required this.onRefresh,
  });

  @override
  State<ReservationDetailsTab> createState() => _ReservationDetailsTabState();
}

class _ReservationDetailsTabState extends State<ReservationDetailsTab>
    with AutomaticKeepAliveClientMixin {
  late final ReservationFormController _formController;
  final _formKey = GlobalKey<FormState>();

  ReservationView? _editSnapshot;
  final _hasChangesNotifier = ValueNotifier(false);

  // By switching tabs unactive tabs are disposed by default.
  // AutomaticKeepAliveClientMixin prevents that
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _formController = ReservationFormController();
    _formController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _formController.dispose();
    _hasChangesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin

    return BlocConsumer<ReservationViewBloc, ReservationViewState>(
      listenWhen: (previous, current) {
        return previous.status != current.status && !current.status.isLoading;
      },
      listener: _listener,
      builder: (context, state) {
        final body = Stack(
          children: [
            _buildContent(context, state),
            if (state.hasReservation && !state.status.isLoading) ...[
              if (state.displayMode.isView)
                Positioned(
                  top: 6,
                  right: 6,
                  child: ReservationActionsMenu(
                    isReservationClosed: state.reservation!.isClosed,
                    onEdit: () {
                      _editSnapshot = state.reservation!;
                      _hasChangesNotifier.value = false;
                      _changeDisplayMode(ReservationFormMode.edit);
                    },
                    onClose: () {
                      context
                          .read<ReservationViewBloc>()
                          .add(CloseReservation(widget.reservationId));
                    },
                    onReopen: () {
                      context
                          .read<ReservationViewBloc>()
                          .add(ReopenReservation(widget.reservationId));
                    },
                    onRemove: () {
                      context
                          .read<ReservationViewBloc>()
                          .add(RemoveReservation(widget.reservationId));
                    },
                  ),
                )
              else if (state.displayMode.isEdit)
                Positioned(
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
                                onPressed: () => _onDiscardPressed(state),
                                child: const Text('Отказ'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ],
        );

        // Allow pull-to-refresh only in view mode
        return Scaffold(
          body: state.displayMode.isView
              ? AppRefreshIndicator(onRefresh: widget.onRefresh, child: body)
              : body,
        );
      },
    );
  }

  // Widget _buildContent(BuildContext context, ReservationViewState state) {
  //   if (!state.hasReservation || state.status.isLoading) {
  //     // Always scrollable to allow pull-to-refresh while loading
  //     return SingleChildScrollView(
  //       physics: const AlwaysScrollableScrollPhysics(),
  //       child: SizedBox(
  //         height: spacingByHeight(context, 0.8),
  //         child: const Center(child: CircularProgressIndicator()),
  //       ),
  //     );
  //   }

  //   final double bottomPadding = state.displayMode.isEdit ? 70.0 : 16.0;

  //   return Center(
  //     child: Padding(
  //       padding: EdgeInsets.fromLTRB(45, 0, 45, bottomPadding),
  //       child: SingleChildScrollView(
  //         physics: const AlwaysScrollableScrollPhysics(),
  //         child: ReservationForm(
  //           formKey: _formKey,
  //           formController: _formController,
  //           displayMode: state.displayMode,
  //           isCreatedByStaff: state.reservation!.isCreatedByStaff,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildContent(BuildContext context, ReservationViewState state) {
    final double bottomPadding = state.displayMode.isEdit ? 70.0 : 16.0;

    final content = Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(45, 0, 45, bottomPadding),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ReservationForm(
            formKey: _formKey,
            formController: _formController,
            displayMode: state.displayMode,
            isCreatedByStaff: state.reservation?.isCreatedByStaff ?? false,
          ),
        ),
      ),
    );

    if (state.status.isLoading && !state.hasReservation) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: spacingByHeight(context, 0.8),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (state.status.isLoading && state.hasReservation) {
      return AbsorbPointer(
        child: Stack(
          children: [
            content,
            Container(
              color: Colors.black.withOpacity(0.3), // semitransparent overlay
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      );
    }

    return content;
  }

  void _listener(BuildContext context, ReservationViewState state) {
    if (state.hasReservation &&
        (state.status.isLoaded || state.status.isUpdated)) {
      _formController.set(state.reservation!);
    }

    if (state.status.isReadyToPop) {
      context.pop(); // Route to the previous page
    } else if (state.status.isUpdated) {
      _changeDisplayMode(ReservationFormMode.view);

      SnackBarService.showSuccess(
          context, 'Резервацията беше обновена успешно.');
    } else if (state.status.isRemoved) {
      SnackBarService.showSuccess(
          context, 'Резервацията беше изтрита успешно.');
    } else if (state.status.isClosed) {
      SnackBarService.showSuccess(
          context, 'Резервацията беше приключена успешно.');
    } else if (state.status.isReopened) {
      SnackBarService.showSuccess(
          context, 'Резервацията беше активирана успешно.');
    } else if (state.hasFailure && state.status.isError) {
      // TODO: Handle error codes when reservation is not accessible - update prev page

      final failure = state.failure!;

      // Indicates a concurrency conflict - the reservation was closed by another user or process
      // while we had still access to close action. We have to update tables tab
      if (failure is ServerFailure &&
          failure.errorCode == ErrorCodes.reservationAlreadyClosed) {
        context.read<ReservationTablesBloc>().add(ReservationClosedEvent());
      }

      SnackBarService.showFailure(context, failure);

      if (failure.requiresReauthentication) {
        context.go(AppRoutes.welcome);
      }
    }
  }

  void _onFormChanged() {
    if (_editSnapshot == null) return;

    final original = _editSnapshot!;

    final (originalDate, originalTime) =
        extractLocalComponentsFromUtc(original.startUtc);

    final hasChanges = _formController.name.text != original.name ||
        _formController.peopleCount.text != original.peopleCount.toString() ||
        _formController.date.text != originalDate.toYYYYMMDDString() ||
        _formController.time.text != originalTime.toHHMMSSString() ||
        _formController.email.text != (original.email ?? '') ||
        _formController.phone.text != (original.phone ?? '') ||
        _formController.comment.text != (original.comment ?? '');

    _hasChangesNotifier.value = hasChanges;
  }

  void _onSavePressed() {
    if (!(_formKey.currentState?.validate() ?? false) ||
        _editSnapshot == null) {
      return;
    }

    final update = _formController.getRequest().toUpdateEntity(_editSnapshot!);

    context
        .read<ReservationViewBloc>()
        .add(UpdateReservation(widget.reservationId, update));
  }

  void _onDiscardPressed(ReservationViewState state) {
    if (!state.hasReservation) return;

    _formKey.currentState?.reset(); // Reset the visual errors of the form
    _formController.set(state.reservation!);

    _changeDisplayMode(ReservationFormMode.view);
  }

  void _changeDisplayMode(ReservationFormMode mode) {
    context.read<ReservationViewBloc>().add(ChangeDisplayMode(mode));
  }
}
