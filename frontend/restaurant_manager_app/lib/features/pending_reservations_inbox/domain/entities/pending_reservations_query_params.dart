enum SortOrder { asc, desc }

class PendingReservationsQueryParams {
  final int page;
  final int limit;
  final SortOrder sortOrder;

  PendingReservationsQueryParams({
    this.page = 1,
    this.limit = 20,
    this.sortOrder = SortOrder.desc,
  });
}
