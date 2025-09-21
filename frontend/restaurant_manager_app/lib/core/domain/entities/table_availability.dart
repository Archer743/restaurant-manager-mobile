enum TableStatus {
  available,
  reserved,
  reservedByCurrent,
}

class TableAvailability {
  final String id;
  final int tableNumber;
  final int capacity;
  final TableStatus status;
  final String? reservationId;

  TableAvailability({
    required this.id,
    required this.tableNumber,
    required this.capacity,
    required this.status,
    this.reservationId,
  });
}
