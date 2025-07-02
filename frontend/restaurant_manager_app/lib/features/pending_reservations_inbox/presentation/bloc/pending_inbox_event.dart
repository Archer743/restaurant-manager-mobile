abstract class PendingInboxEvent {}

/// Used for initial load or refresh (pull-to-refresh)
class GetPendingReservations extends PendingInboxEvent {
  final bool isRefresh;

  GetPendingReservations({this.isRefresh = false});
}

class LoadNextPage extends PendingInboxEvent {}
