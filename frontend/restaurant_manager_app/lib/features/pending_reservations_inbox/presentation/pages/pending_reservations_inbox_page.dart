import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pending_reservation_preview.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/presentation/bloc/pending_inbox_bloc.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/presentation/bloc/pending_inbox_event.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/presentation/bloc/pending_inbox_state.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/presentation/widgets/pending_reservation_card.dart';

class PendingReservationsInboxPage extends StatefulWidget {
  const PendingReservationsInboxPage({super.key});

  @override
  State<PendingReservationsInboxPage> createState() =>
      _PendingReservationsInboxPageState();
}

class _PendingReservationsInboxPageState
    extends State<PendingReservationsInboxPage> {
  // Controller to detect scroll position for infinite scrolling
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Check if the user has scrolled to the very end of the list
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<PendingInboxBloc>().add(LoadNextPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Чакащи резервации')),
      body: BlocConsumer<PendingInboxBloc, PendingInboxState>(
        listener: (context, state) {
          if (state is PendingInboxError) {
            SnackBarService.showFailure(context, state.failure);

            if (state.failure.requiresReauthentication) {
              context.go(AppRoutes.welcome);
            }
          }
        },
        builder: (context, state) {
          if (state is PendingInboxLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PendingInboxLoaded) {
            final List<PendingReservationPreview> reservations =
                state.reservations;
            final bool hasNextPage = state.hasNextPage;
            final bool isLoadingMore = state is PendingInboxLoadingMore;

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<PendingInboxBloc>()
                    .add(GetPendingReservations(isRefresh: true));

                // Wait until a loaded or error state is emitted after refresh
                await context.read<PendingInboxBloc>().stream.firstWhere(
                    (s) => s is PendingInboxLoaded || s is PendingInboxError);
              },
              child: reservations.isEmpty
                  ? _buildNoReservationsFound()
                  : _buildReservationList(
                      reservations, hasNextPage, isLoadingMore),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildNoReservationsFound() {
    return SingleChildScrollView(
      // Ensures scrolling even if content is small
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: spacingByHeight(context, 0.7),
        child: const Center(child: Text('Няма чакащи резервации')),
      ),
    );
  }

  Widget _buildReservationList(List<PendingReservationPreview> reservations,
      bool hasNextPage, bool isLoadingMore) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: reservations.length + (hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < reservations.length) {
            final r = reservations[index];
            return GestureDetector(
                child: PendingReservationCard(reservation: r),
                onTap: () {
                  // final calendarBloc = context.read<CalendarBloc>();
                  // context.push(
                  //   '${AppRoutes.reservation}/${r.id}',
                  //   extra: calendarBloc,
                  // );
                });
          } else {
            // This is the loading indicator at the bottom
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: isLoadingMore
                    ? const CircularProgressIndicator()
                    : const SizedBox.shrink(),
              ),
            );
          }
        });
  }
}
