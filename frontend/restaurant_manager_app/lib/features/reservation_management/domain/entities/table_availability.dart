enum TableStatus {
  available,
  occupiedByOther,
  reservedByCurrent,
}

class TableAvailability {
  final String id;
  final int tableNumber;
  final int capacity;
  final TableStatus status;

  TableAvailability({
    required this.id,
    required this.tableNumber,
    required this.capacity,
    required this.status,
  });
}
