import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pending_reservation_preview.dart';

abstract class PendingInboxState {}

class PendingInboxInitial extends PendingInboxState {}

class PendingInboxLoading extends PendingInboxState {}

class PendingInboxLoaded extends PendingInboxState {
  final List<PendingReservationPreview> reservations;
  final bool hasNextPage;

  PendingInboxLoaded({
    required this.reservations,
    required this.hasNextPage,
  });
}

class PendingInboxLoadingMore extends PendingInboxLoaded {
  PendingInboxLoadingMore({
    required super.reservations,
    required super.hasNextPage,
  });
}

class PendingInboxError extends PendingInboxState {
  final Failure failure;

  PendingInboxError(this.failure);
}
