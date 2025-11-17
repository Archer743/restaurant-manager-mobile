import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pagination_metadata.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pending_reservation_preview.dart';

class PagedResult {
  final List<PendingReservationPreview> items;
  final PaginationMetadata pagination;

  PagedResult({
    required this.items,
    required this.pagination,
  });
}
